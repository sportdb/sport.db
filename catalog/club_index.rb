

module CatalogDb

class ClubIndex

  def self.build( path )
    pack = SportDb::Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_clubs do |entry|
      recs += SportDb::Import::ClubReader.parse( entry.read )
    end
    recs

    clubs = new
    clubs.add( recs )

    ## add wiki(pedia) anchored links
    # recs = []
    # pack.each_clubs_wiki do |entry|
    #   recs += WikiReader.parse( entry.read )
    # end

    # pp recs
    # clubs.add_wiki( recs )
    clubs
  end


  def catalog() Import.catalog; end

  def initialize
    @clubs          = {}   ## clubs (indexed) by canonical name
    @clubs_by_name  = {}
    @errors         = []
  end

  attr_reader :errors
  def errors?() @errors.empty? == false; end

  def mappings() @clubs_by_name; end   ## todo/check: rename to index or something - why? why not?
  def clubs()    @clubs.values;  end
  alias_method :all, :clubs      ## use ActiveRecord-like alias for clubs


  ## helpers from club - use a helper module for includes - why? why not?
  include SportDb::NameHelper
  ## incl. strip_year( name )
  ##       has_year?( name)
  ##       strip_lang( name )
  ##       normalize( name )

  def strip_wiki( name )     # todo/check: rename to strip_wikipedia_en - why? why not?
    ##  change/rename to strip_wiki_qualifier or such - why? why not?
    ## note: strip disambiguationn qualifier from wikipedia page name if present
    ##        note: only remove year and foot... for now
    ## e.g. FC Wacker Innsbruck (2002) => FC Wacker Innsbruck
    ##      Willem II (football club)  => Willem II
    ##
    ## e.g. do NOT strip others !! e.g.
    ##   América Futebol Clube (MG)
    ##  only add more "special" cases on demand (that, is) if we find more
    name = name.gsub( /\([12][^\)]+?\)/, '' ).strip  ## starting with a digit 1 or 2 (assuming year)
    name = name.gsub( /\(foot[^\)]+?\)/, '' ).strip  ## starting with foot (assuming football ...)
    name
  end

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
      club = Model::Club.create!(
                    key:  rec.key,
                    name: rec.name,
                    code: rec.code, 
                    # alt_names:  - fix!!!! 
                    country: country( rec.country ),                
      )
      pp club
   
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


      norms = names.map do |name|
        ## check lang codes e.g. [en], [fr], etc.
        ##  todo/check/fix:  move strip_lang up in the chain - check for duplicates (e.g. only lang code marker different etc.) - why? why not?
        name = strip_lang( name )
        norm = normalize( name )
        norm
      end

      norms = norms.uniq  

      norms.each do |norm|
          Model::ClubName.create!( club_id: club.id, 
                                   name:    norm )
      end
    end
  end # method add


  ## helper to always convert (possible) country key to existing country record
  ##  todo: make private - why? why not?
  def country( country )
    if country.is_a?( String ) || country.is_a?( Symbol )       
        puts "** !!! ERROR !!! - struct expect for now for country >#{country}<; sorry"
        exit 1
    end

    ## (re)use country struct - no need to run lookup again
    rec = Model::Country.find_by!( key: country.key )
    rec  
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
end   # module CatalogDb
