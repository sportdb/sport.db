module CatalogDb
module Metal

class Club < Record
    self.tablename = 'clubs'

    self.columns = ['key', 
                    'name', 
                    'code', 
                    'country_key']

    def self._build_club( row )
        ## note: cache structs by key (do NOT rebuild duplicates; reuse)
        @cache ||= Hash.new
        @cache[ row[0] ] ||= begin 
                                club = Sports::Club.new(
                                         key: row[0],
                                         name: row[1],
                                         code: row[2] )
                                ## note: country for now NOT supported 
                                ##       via keyword on init!!!
                                ##    fix - why? why not?
                                club.country = row[3] ? _to_country( row[3] ) : nil
                                club 
                              end   
                                                   
    end                
 

    def self._find_by_name( name )
        rows = execute( <<-SQL )
        SELECT #{self.columns.join(', ')}
        FROM clubs 
        INNER JOIN club_names ON clubs.key  = club_names.key
        WHERE club_names.name = '#{name}' 
SQL
       rows 
    end


  ## todo/fix/check: use rename to find_canon  or find_canonical() or something??
  ##  remove (getting used?) - why? why not?
  # def []( name )    ## lookup by canoncial name only;  todo/fix: add find alias why? why not?
  #  puts "WARN!! do not use ClubIndex#[] for lookup >#{name}< - will get removed!!!"
  #  @clubs[ name ]
  # end


  def self.match( name )
    # note: returns empty array (e.g. []) if no match and NOT nil
    q  = normalize( name )
    rows = _find_by_name( q )

    ## no match - retry with unaccented variant if different
    ##    e.g. example is Preussen Münster  (with mixed accent and unaccented letters) that would go unmatched for now
    ##      Preussen Münster => preussenmünster (norm) 
    ##                       => preussenmunster (norm+unaccent)
    ##
    ##  todo/fix - make always use norm+unaccent ?? rebuild names
    ##                      always add all unaccent veriants  -  why? why not?
    if rows.empty?
      ## note: unaccent pulled in via alphabets gem (global method)
      q2 =  normalize(unaccent( name ))
      if q2 != q
        puts "  retry with unaccent name >#{name}< => >#{q2}<"
        rows = _find_by_name( q2 ) 
      end
    end
     
    rows.map {|row| _build_club( row )}
  end



  ## match - always returns an array (with one or more matches) or nil
  def self.match_by( name:, 
                    country: nil )
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now
    recs = match( name ) 

   ###
   ## todo/fix:  use a sql query here for country check too!!!
   ##               see leagues for example
   ##             needs to fix special case with unaccent first (or ignore) - why? why not?

    if country
      country = _country( country )

      ## note: match must for now always include name
      ## filter by country
      recs = recs.select { |club| club.country && 
                                  club.country.key == country.key }
    end
    recs
  end

 
 ##########
 #  "legacy" finders - return zero or one club 
 ##    (if more than one match, exit/raise error/exception) 


  def self.find( name )   find_by( name: name, country: nil ); end
  def self.find!( name )  find_by!( name: name, country: nil ); end

  ## find - always returns a single record / match or nil
  ##   if there is more than one match than find aborts / fails
  def self.find_by!( name:, country: nil )    ## todo/fix: add international or league flag?
    club = self.find_by( name: name, country: country )

    if club.nil?
      puts "** !!! ERROR - no match for club >#{name}<"
      exit 1
    end

    club
  end

  def self.find_by( name:, country: nil )    ## todo/fix: add international or league flag?
    ## note: allow passing in of country key too (auto-counvert)
    ##       and country struct too
    ##     - country assumes / allows the country key or fifa code for now
    recs = nil

    if country
      country = _country( country )

      recs = match_by( name: name, country: country )

      if recs.empty?
        ## (re)try with second country - quick hacks for known leagues
        ##  todo/fix: add league flag to activate!!!  - why? why not
        recs = match_by( name: name, country: 'wal' )  if country.key == 'eng'
        recs = match_by( name: name, country: 'eng' )  if country.key == 'sco'
        recs = match_by( name: name, country: 'nir' )  if country.key == 'ie'
        recs = match_by( name: name, country: 'mc' )   if country.key == 'fr'
        recs = match_by( name: name, country: 'li' )   if country.key == 'ch'
        recs = match_by( name: name, country: 'ca' )   if country.key == 'us'
        recs = match_by( name: name, country: 'nz' )   if country.key == 'au'
      end
    else  ## try "global" search - no country passed in
      recs = match( name )
    end

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
end  # class Club

end  # module Metal
end  # module CatalogDb

