# encoding: utf-8

module SportDb
  module Import

##
#  note: use our own (internal) club struct for now - why? why not?
#    - check that shape/structure/fields/attributes match
#      the Team struct in sportdb-text (in SportDb::Struct::Team)  !!!!
class Club
  ##  todo: use just names for alt_names - why? why not?
  attr_accessor :name, :alt_names,
                :year, :ground, :city

  ## more attribs - todo/fix - also add "upstream" to struct & model!!!!!
  attr_accessor :district, :geos, :year_end, :country

  ## special import only attribs
  attr_accessor :alt_names_auto    ## auto-generated alt names

  def historic?()  @year_end ? true : false; end
  alias_method  :past?, :historic?

  def initialize
    @alt_names      = []
    @alt_names_auto = []
  end


  ## helper methods for import only
  ## check for duplicates
  def duplicates?
    names = [name] + alt_names + alt_names_auto
    names = names.map { |name| normalize( name ) }

    names.size != names.uniq.size
  end

  def duplicates
    names = [name] + alt_names + alt_names_auto

    ## calculate (count) frequency and select if greater than one
    names.reduce( Hash.new ) do |h,name|
       norm = normalize( name )
       h[norm] ||= []
       h[norm] << name; h
    end.select { |norm,names| names.size > 1 }
  end

  def add_variants( name_or_names )
    names = name_or_names.is_a?(Array) ? name_or_names : [name_or_names]
    names.each do |name|
      name = sanitize( name )
      self.alt_names_auto += variants( name )
    end
  end

   ###################################
   # "global" helper - move to ___ ? why? why not?

   YEAR_REGEX = /\([0-9,\- ]+?\)/
   def self.strip_year( name )
     ## check for year(s) e.g. (1887-1911), (-2013),
     ##                        (1946-2001, 2013-) etc.
     name.gsub( YEAR_REGEX, '' ).strip
   end

   def self.has_year?( name ) name =~ YEAR_REGEX; end

   LANG_REGEX = /\[[a-z]{2}\]/
   def self.strip_lang( name )
     name.gsub( LANG_REGEX, '' ).strip
   end

   def self.has_lang?( name ) name =~ LANG_REGEX; end

   NORM_REGEX =  /[.'º\-\/]/
   ## note: remove all dots (.), dash (-), ', º, /, etc.
   ##         for norm(alizing) names
   def self.strip_norm( name )
     name.gsub( NORM_REGEX, '' )
   end

   def strip_year( name ) self.class.strip_year( name ); end
   def strip_lang( name ) self.class.strip_lang( name ); end
   def strip_norm( name ) self.class.strip_norm( name ); end

private
  def sanitize( name )
    ## check for year(s) e.g. (1887-1911), (-2013),
    ##                        (1946-2001,2013-) etc.
    name = strip_year( name )
    ## check lang codes e.g. [en], [fr], etc.
    name = strip_lang( name )
    name
  end

  def normalize( name )
    name = sanitize( name )

    ## remove all dots (.), dash (-), º, /, etc.
    name = strip_norm( name )
    name = name.gsub( ' ', '' )  # note: also remove all spaces!!!

    ## todo/fix: use our own downcase - why? why not?
    name = name.downcase     ## do NOT care about upper and lowercase for now
    name
  end

  def variants( name )  Variant.find( name ); end
end # class Club




class ClubIndex

  def initialize
    @clubs          = {}   ## clubs (indexed) by canonical name
    @clubs_by_name  = {}
    @errors         = []
  end

  attr_reader :errors
  def errors?() @errors.empty? == false; end

  def mappings() @clubs_by_name; end   ## todo/check: rename to index or something - why? why not?
  def clubs()    @clubs.values;  end


  ## helpers from club - use a helper module for includes - why? why not?
  def strip_year( name ) Club.strip_year( name ); end
  def has_year?( name)   Club.has_year?( name ); end
  def strip_lang( name ) Club.strip_lang( name ); end
  def strip_norm( name ) Club.strip_norm( name ); end



  def add( rec_or_recs )   ## add club record / alt_names
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## puts "adding:"
      ## pp rec
      ### step 1) add canonical name
      old_rec = @clubs[ rec.name ]
      if old_rec
        puts "** !!! ERROR !!! - (canonical) name conflict - duplicate - >#{rec.name}< will overwrite >#{old_rec.name}<:"
        pp old_rec
        pp rec
        exit 1
      else
        @clubs[ rec.name ] = rec
      end

      ## step 2) add all names (canonical name + alt names + alt names (auto))
      names = [rec.name] + rec.alt_names
      more_names = []
      ## check "hand-typed" names for year (auto-add)
      ## check for year(s) e.g. (1887-1911), (-2013),
      ##                        (1946-2001,2013-) etc.
      names.each do |name|
        if has_year?( name )
          more_names <<  strip_year( name )
        end
      end

      names += more_names
      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s):"
        pp names
        pp rec
        exit 1
      end

      ## check with auto-names just warn for now and do not exit
      names += rec.alt_names_auto
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! WARN !!! - #{count-count_uniq} duplicate name(s):"
        pp names
        pp rec
      end


      names.each_with_index do |name,i|
        ## check lang codes e.g. [en], [fr], etc.
        name = strip_lang( name )
        norm = normalize( name )
        alt_recs = @clubs_by_name[ norm ]
        if alt_recs
          ## check if include club rec already or is new club rec
          if alt_recs.include?( rec )
            ## note: do NOT include duplicate club record
            msg = "** !!! WARN !!! - (norm) name conflict/duplicate for club - >#{name}< normalized to >#{norm}< already included >#{rec.name}, #{rec.country.name}<"
            puts msg
            @errors << msg
          else
            msg = "** !!! WARN !!! - name conflict/duplicate - >#{name}< will overwrite >#{alt_recs[0].name}, #{alt_recs[0].country.name}< with >#{rec.name}, #{rec.country.name}<"
            puts msg
            @errors << msg
            alt_recs << rec
          end
        else
          @clubs_by_name[ norm ] = [rec]
        end
      end
    end
  end # method add


  def []( name )    ## lookup by canoncial name only
    @clubs[ name ]
  end

  def match( name )
    ## todo/check: return empty array if no match!!! and NOT nil (add || []) - why? why not?
    name = normalize( name )
    @clubs_by_name[ name ]
  end


  def match_by( name:, country: )
    ## note: match must for now always  include name
    m = match( name )
    if m    ## filter by country
      ## note: country assumes / allows the country key or fifa code for now
      country_rec = SportDb::Import.config.countries[ country ]
      if country_rec.nil?
        puts "** !!! ERROR !!! - unknown country >#{country}< - no match found, sorry - add to world/countries.txt in config"
        exit 1
      end

      m = m.select { |club| club.country.key == country_rec.key }
      m = nil   if m.empty?     ## note: reset to nil if no more matches
    end
    m
  end



  def dump_duplicates # debug helper - report duplicate club name records
     @clubs_by_name.each do |name, clubs|
       if clubs.size > 1
         puts "#{clubs.size} matching club duplicates for >#{name}<:"
         pp clubs
       end
     end
  end



private
  def normalize( name )
    name = strip_norm( name )
    name = name.gsub( ' ', '' )   # remove all spaces

    ## todo/fix: use our own downcase - why? why not?
    name = name.downcase     ## do NOT care about upper and lowercase for now
    name
  end
end # class ClubIndex


end   # module Import
end   # module SportDb
