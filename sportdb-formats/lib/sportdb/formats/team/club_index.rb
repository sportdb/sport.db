# encoding: utf-8

module SportDb
  module Import


class ClubIndex

  def self.build( path )
    pack = Package.new( path )   ## lets us use direcotry or zip archive

    recs = []
    pack.each_clubs do |entry|
      recs += Club.parse( entry.read )
    end
    recs

    clubs = new
    clubs.add( recs )

    ## add wiki(pedia) anchored links
    recs = []
    pack.each_clubs_wiki do |entry|
       recs += WikiReader.parse( entry.read )
    end

    pp recs
    clubs.add_wiki( recs )
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
  include NameHelper
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


  ## todo/fix/check: use rename to find_canon  or find_canonical() or something??
  ##  remove (getting used?) - why? why not?
  def []( name )    ## lookup by canoncial name only;  todo/fix: add find alias why? why not?
    puts "WARN!! do not use ClubIndex#[] for lookup >#{name}< - will get removed!!!"
    @clubs[ name ]
  end


  def match( name )
    # note: returns empty array (e.g. []) if no match and NOT nil
    name = normalize( name )
    m = @clubs_by_name[ name ] || []

    ## no match - retry with unaccented variant if different
    ##    e.g. example is Preussen Münster  (with mixed accent and unaccented letters) that would go unmatched for now
    ##      Preussen Münster => preussenmünster (norm) => preussenmunster (norm+unaccent)
    if m.empty?
      name2 = unaccent( name )
      if name2 != name
        m = @clubs_by_name[ name2 ] || []
      end
    end
    m
  end


  ## helper to always convert (possible) country key to existing country record
  ##  todo: make private - why? why not?
  def country( country )
    if country.is_a?( String ) || country.is_a?( Symbol )
      ## note:  use own "global" countries index setting for ClubIndex - why? why not?
      rec = catalog.countries.find( country.to_s )
      if rec.nil?
        puts "** !!! ERROR !!! - unknown country >#{country}< - no match found, sorry - add to world/countries.txt in config"
        exit 1
      end
      rec
    else
      country  ## (re)use country struct - no need to run lookup again
    end
  end


  ## match - always returns an array (with one or more matches) or nil
  def match_by( name:, country: nil )
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now
    m = match( name )

    if country
      country = country( country )

      ## note: match must for now always  include name
      ## filter by country
      m = m.select { |club| club.country.key == country.key }
    end
    m
  end

  def find( name )   find_by( name: name, country: nil ); end
  def find!( name )  find_by!( name: name, country: nil ); end

  ## find - always returns a single record / match or nil
  ##   if there is more than one match than find aborts / fails
  def find_by!( name:, country: nil )    ## todo/fix: add international or league flag?
    club = find_by( name: name, country: country )

    if club.nil?
      puts "** !!! ERROR - no match for club >#{name}<"
      exit 1
    end

    club
  end


  def find_by( name:, country: nil )    ## todo/fix: add international or league flag?
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now
    m = nil

    if country
      country = country( country )

      m = match_by( name: name, country: country )

      if m.empty?
        ## (re)try with second country - quick hacks for known leagues
        ##  todo/fix: add league flag to activate!!!  - why? why not
        m = match_by( name: name, country: 'wal' )  if country.key == 'eng'
        m = match_by( name: name, country: 'eng' )  if country.key == 'sco'
        m = match_by( name: name, country: 'nir' )  if country.key == 'ie'
        m = match_by( name: name, country: 'mc' )   if country.key == 'fr'
        m = match_by( name: name, country: 'li' )   if country.key == 'ch'
        m = match_by( name: name, country: 'ca' )   if country.key == 'us'
      end
    else  ## try "global" search - no country passed in
      m = match( name )
    end


    club = nil
    if m.empty?
      ## puts "** !!! WARN !!! no match for club >#{name}<"
    elsif m.size > 1
      puts "** !!! ERROR - too many matches (#{m.size}) for club >#{name}<:"
      pp m
      exit 1
    else   # bingo; match - assume size == 1
      club = m[0]
    end

    club
  end



  def build_mods( mods )
    ## e.g.
    ##  { 'Arsenal   | Arsenal FC'    => 'Arsenal, ENG',
    ##    'Liverpool | Liverpool FC'  => 'Liverpool, ENG',
    ##    'Barcelona'                 => 'Barcelona, ESP',
    ##    'Valencia'                  => 'Valencia, ESP' }

    mods.reduce({}) do |h,(club_names, club_line)|

      values = club_line.split( ',' )
      values = values.map { |value| value.strip }  ## strip all spaces

      ## todo/fix: make sure country is present !!!!
      club_name, country_name = values
      club = find_by!( name: club_name, country: country_name )

      values = club_names.split( '|' )
      values = values.map { |value| value.strip }  ## strip all spaces

      values.each do |club_name|
        h[club_name] = club
      end
      h
    end
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
