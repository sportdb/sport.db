###
#  note - extend all structs for with search api
#
#  todo - add more helpers!!!!
#
#
#  todo - fix - move all non-core search functionality/machinery
#                  over here - why? why not?


module Sports
###
## todo/fix - add find_by( code: ), find_by( name: )
##                   split - why? why not?


class League
    def self._search() CatalogDb::Metal::League; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def self.match_by( name: nil, code: nil, country: nil )
    ## todo/fix upstream - remove "generic" match_by() - why? why not?
    ###
    if code && name.nil?
     _search.match_by_code( code, country: country )
   elsif name && code.nil?
     _search.match_by_name( name, country: country )
   else
     raise ArgumentError, "LeagueSearch#match_by - one (and only one arg) required - code: or name:"
   end
   ## @service.match_by( name: name,
   ##                   country: country )
 end

 ## all-in-one query (name or code)
 def self.match( q, country: nil )
    _search.match_by_name_or_code( q, country: country )
 end

  ###############
  ### more deriv support functions / helpers
  def self.find!( q )
    league = find( q )
    if league.nil?
      puts "** !!! ERROR - no league match found for >#{q}<, add to leagues table; sorry"
      exit 1
    end
    league
  end

  def self.find( q )
    league = nil
    recs = match( q )
    # pp m

    if recs.empty?
      ## fall through/do nothing
    elsif recs.size > 1
      puts "** !!! ERROR - ambigious league query; too many leagues (#{recs.size}) found:"
      pp recs
      exit 1
    else
      league = recs[0]
    end

    league
  end
end # class League


class NationalTeam
    def self._search() CatalogDb::Metal::NationalTeam; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?

  ## changle core api to match( q ) only - why? why not?
  ##   and make find and find! derivs???
  def self.find( q )    _search.find( q ); end
  def self.find!( q )   _search.find!( q ); end
end # class NationalTeam



class Club
    def self._search() CatalogDb::Metal::Club; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?

  ## add mods here - why? why not?
  def self.match_by( name:, country: nil,
                       league:  nil,
                       mods:    nil )
    ## for now assume "global" mods  - checks only for name
    ##
    if mods && mods[ name ]
      club = mods[ name ]
      return [club]   # note: wrap (single record) in array
    end

    ## note: add "auto-magic" country calculation via league record
    ##            if league is a national league for football clubs
    if league
        raise ArgumentError, "match_by - league AND country NOT supported; sorry"  if country
### find countries via league
###     support league.intl? too - why? why not?
###       or only nationa league
        raise ArgumentError, "match_by - league - only national club leagues supported (not int'l or national teams for now); sorry"   unless league.national? && league.clubs?

        ### calc countries
        ### uses "global" func in sports-catalogs for now
        ##   move code here - why? why not?
        country = find_countries_for_league( league )
        _search.match_by( name:    name,
                           country: country )
    else
        _search.match_by( name:    name,
                           country: country )
    end
  end


  ## todo/fix/check: use rename to find_canon  or find_canonical() or something??
  ##  remove (getting used?) - why? why not?
  # def []( name )    ## lookup by canoncial name only;  todo/fix: add find alias why? why not?
  #  puts "WARN!! do not use ClubIndex#[] for lookup >#{name}< - will get removed!!!"
  #  @clubs[ name ]
  # end


  ###############
  ### more deriv support functions / helpers
  def self.match( name ) match_by( name: name ); end

  ##########
  #  "legacy" finders - return zero or one club
  ##    (if more than one match, exit/raise error/exception)
  def self.find( name )   find_by( name: name ); end
  def self.find!( name )  find_by!( name: name ); end

  ## find - always returns a single record / match or nil
  ##   if there is more than one match than find aborts / fails
  def self.find_by!( name:, country: nil,
                            league:  nil )    ## todo/fix: add international or league flag?
    club = find_by( name:    name,
                    country: country,
                    league:  league )

    if club.nil?
      puts "** !!! ERROR - no match for club >#{name}<"
      exit 1
    end

    club
  end


  def self.find_by( name:, country: nil,
                      league:  nil )    ## todo/fix: add international or league flag?
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now
    recs = match_by( name:    name,
                     country: country,
                     league:  league )

    club = nil
    if recs.empty?
      ## puts "** !!! WARN !!! no match for club >#{name}<"
    elsif recs.size > 1
      puts "** !!! ERROR - too many matches (#{recs.size}) for club >#{name}<:"
      pp recs
      exit 1
    else   # bingo; match - assume size == 1
      club = recs[0]
    end

    club
  end


#######
# more support methods
  def self.build_mods( mods )
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
  end # class Club



  class Team
    ## note: "virtual" index lets you search clubs and/or national_teams (don't care)

        ## todo/check: rename to/use map_by! for array version - why? why not?
        def self.find_by!( name:, league:, mods: nil )
          if name.is_a?( Array )
            recs = []
            name.each do |q|
              recs << _find_by!( name: q, league: league, mods: mods )
            end
            recs
          else  ## assume single name
            _find_by!( name: name, league: league, mods: mods )
          end
        end


      CLUB_NAME_RE =  %r{^
              (?<name>[^()]+?)     ## non-greedy
              (?:
                 \s+
                 \(
                   (?<code>[A-Z][A-Za-z]{2,3})    ## optional (country) code; support single code e.g. (A) - why? why not?
                 \)
              )?
            $}x   ## note - allow (URU) and (Uru) - why? why not


        ###
        #  note:  missing teams will get
        ##            auto-created if possible
        ##         only ambigious results (too many matches) raise expection!!!
        def self._find_by!( name:, league:, mods: nil )
          if mods && mods[ league.key ] && mods[ league.key ][ name ]
            mods[ league.key ][ name ]
          else
            if league.clubs?
              if league.intl?    ## todo/fix: add intl? to ActiveRecord league!!!
                     ###
                     ##  get country code from name
                     ##    e.g. Liverpool FC (ENG) or
                     ##         Liverpool FC (URU) etc.

                     ## check for country code
                     if m=CLUB_NAME_RE.match( name )
                       if m[:code]
                         Club.find_by!( name: m[:name],
                                                country: m[:code] )
                       else
                          Club.find!( name )
                       end
                     else
                       puts "!! PARSE ERROR - invalid club name; cannot match with CLUB_NAME_RE >#{team}<"
                       exit 1
                     end
              else  ## assume clubs in domestic/national league tournament
                 ## note - search by league countries (may incl. more than one country
                 ##             e.g. us incl. ca, fr incl. mc, ch incl. li, etc.
                rec = Club.find_by( name: name, league: league )
                if rec.nil?
                    puts "auto-create (missing) club #{name}"
                    ##  todo/fix: add auto flag!!!!
                    ###              like in rounds!!!
                    ##   to track auto-created clubs
                    rec = Club.new( name: name )
                    rec.country = league.country  ## fix: country kwarg not yet supported!!
                    pp rec
                end
                rec
              end
            else   ## assume national teams (not clubs)
              NationalTeam.find!( name )
            end
          end
        end # method _find_by!
  end # class Team



  class EventInfo
    def self._search() CatalogDb::Metal::EventInfo; end

    def self.find_by( league:, season: )
        _search.find_by( league: league,
                         season: season )
    end
  end # class EventInfo



  class Ground
    def self._search() CatalogDb::Metal::Ground; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def self.match_by( name:, country: nil, city: nil )
    _search.match_by( name:    name,
                       country: country,
                       city:    city )
  end

  ###############
  ### more deriv support functions / helpers
  def self.match( name ) match_by( name: name ); end
  ## add more here - why? why not?
  end # class Ground



  class Player
    def self._search() CatalogDb::Metal::Player; end

  ###################
  ## core required delegates  - use delegate generator - why? why not?
  def self.match_by( name:, country: nil, year: nil )
    _search.match_by( name:    name,
                       country: country,
                       year:    year )
  end

  ###############
  ### more deriv support functions / helpers
  def self.match( name ) match_by( name: name ); end
  ## add more here - why? why not?
  end   # class Player

end   # module Sports
