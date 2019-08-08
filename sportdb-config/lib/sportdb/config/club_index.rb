# encoding: utf-8

module SportDb
  module Import


class ClubIndex

  def self.build( path )
    recs = []
    datafiles = Configuration.find_datafiles_clubs( path )
    datafiles.each do |datafile|
      recs += ClubReader.read( datafile )
    end
    recs

    clubs = self.new
    clubs.add( recs )

    ## add wiki(pedia) anchored links
    recs = []
    datafiles = Configuration.find_datafiles_clubs_wiki( path )
    datafiles.each do |datafile|
       recs += WikiReader.read( datafile )
    end

    pp recs
    clubs.add_wiki( recs )
    clubs
  end



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
  def strip_wiki( name ) Club.strip_wiki( name ); end
  def normalize( name )  Club.normalize( name ); end


  def add_wiki( rec_or_recs )   ## add wiki(pedia club record / links
    recs = rec_or_recs.is_a?( Array ) ? rec_or_recs : [rec_or_recs]      ## wrap (single) rec in array

    recs.each do |rec|
      ## note: strip qualifier () from wikipedia page name if present
      ## e.g. FC Wacker Innsbruck (2002) => FC Wacker Innsbruck
      ##      Willem II (football club)  => Willem II
      ##
      ## e.g. do NOT strip others !! e.g.
      ##   América Futebol Clube (MG)
      ##  only add more "special" cases on demand (that, is) if we find more
      name = strip_wiki( rec.name )

      m = match_by( name: name, country: rec.country )
      if m.nil?
        puts "** !!! ERROR !!! - no matching club found for wiki(pedia) name >#{name}, #{rec.country.name} (#{rec.country.key})<; sorry - to fix add name to clubs"
        exit 1
      end
      if m.size > 1
        puts "** !!! ERROR !!! - too many (greater than one) matching clubs found for wiki(pedia) name >#{name}, #{rec.country.name} (#{rec.country.key})<"
        pp m
        exit 1
      end
      club = m[0]
      club.wikipedia = rec.name
    end
  end  # method add_wiki


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
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
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

      ## note: allow passing in of country struct too
      country_rec = if country.is_a?( SportDb::Import::Country )
                       country   ## (re)use country struct - no need to run lookup again
                    else
                       rec = SportDb::Import.config.countries[ country ]
                       if rec.nil?
                         puts "** !!! ERROR !!! - unknown country >#{country}< - no match found, sorry - add to world/countries.txt in config"
                         exit 1
                       end
                       rec
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
end # class ClubIndex


end   # module Import
end   # module SportDb
