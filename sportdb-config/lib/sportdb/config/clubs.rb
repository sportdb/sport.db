# encoding: utf-8

module SportDb
  module Import

##
#  note: use our own (internal) club struct for now - why? why not?
#    - check that shape/structure/fields/attributes match
#      the Team struct in sportdb-text (in SportDb::Struct::Team)  !!!!
class Club
  ##  todo: use just names for alt_names - why? why not?
  attr_accessor :name, :alt_names, :year, :ground, :city

  ## more attribs - todo/fix - also add "upstream" to struct & model!!!!!
  attr_accessor :district, :geos, :year_end, :country

  def historic?()  @year_end ? true : false; end
  alias_method  :past?, :historic?

  def initialize
    @alt_names = []
  end
end # class Club



class ClubIndex

  def initialize
    @clubs          = {}   ## clubs (indexed) by canonical name
    @clubs_by_name  = {}
    @errors         = []
  end

  attr_reader :errors
  def errors?() @errors.empty? == false; end


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

      ## step 2) add all names (canonical name + alt names)
      names = [rec.name] + rec.alt_names

      ## check for duplicates - simple check for now - fix/improve
      ## todo/fix: (auto)remove duplicates - why? why not?
      count      = names.size
      count_uniq = names.uniq.size
      if count != count_uniq
        puts "** !!! ERROR !!! - #{count-count_uniq} duplicate name(s):"
        pp rec
        exit 1
      end

      names.each_with_index do |name,i|
        alt_recs = @clubs_by_name[ name ]
        if alt_recs
          msg = "** !!! WARN !!! - name conflict/duplicate - >#{name}< will overwrite >#{alt_recs[0].name}, #{alt_recs[0].country.name}< with >#{rec.name}, #{rec.country.name}<"
          puts msg
          @errors << msg
          alt_recs << rec
        else
          @clubs_by_name[ name ] = [rec]
        end
      end
    end
  end # method add


  def []( name )    ## lookup by canoncial name only
    @clubs[ name ]
  end

  def match( name )
    ## todo/check: return empty array if no match!!! and NOT nil (add || []) - why? why not?
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
         puts "#{clubs.size} duplicates for >#{name}<:"
         pp clubs
       end
     end
  end

end # class ClubIndex


end   # module Import
end   # module SportDb
