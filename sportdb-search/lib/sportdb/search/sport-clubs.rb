
module Sports


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

end  # module Sports