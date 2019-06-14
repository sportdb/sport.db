# encoding: utf-8


module SportDb
module Import


class TeamReader


def self.from_file( path )   ## use - rename to read_file - why? why not?
  txt = File.open( path, 'r:utf-8' ).read
  read( txt )
end


def self.read( txt )   ## rename to parse - why? why not? and use read for file read?
  recs = []
  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline comments too
    ##  e.g Eupen        => KAS Eupen,    ## [de]
    ##   => Eupen        => KAS Eupen,
    line = line.sub( /#.*/, '' ).strip

    pp line
    names_line, team_line = line.split( '=>' )

    names = names_line.split( /[|,]/ )   # team names - allow comma(,) or pipe(|)
    team  = team_line.split( ',' )   # (canoncial) team name, team_city

    ## remove leading and trailing spaces
    names = names.map { |name| name.strip }
    team  = team.map { |team| team.strip }
    pp names
    pp team

    canonical_name = team[0]
    city           = team[1]

    ## squish (white)spaces
    #   e.g. New York FC      (2011-)  => New York FC (2011-)
    #   e.g. León     › Guanajuato     => León › Guanajuato
    canonical_name = canonical_name.gsub( /[ \t]+/, ' ' )
    city           = city.gsub( /[ \t]+/, ' ' )   if city

    ## note:
    ##   check/todo!!!!!!!!!!!!!!!!!-
    ##  strip year if to present e.g. (2011-)
    ##
    ##  do NOT strip for defunct / historic clubs e.g.
    ##    (1899-1910)
    ## or (-1914) or (-2011) etc.



    ###
    ##  todo: move year out of canonical team name - why? why not?
    ##

    ## check if canonical name include (2011-) or similar in name
    ##   if yes, remove (2011-) and add to (alt) names
    ##   e.g. New York FC (2011) => New York FC
    if canonical_name =~ /\(.+?\)/   ## note: use non-greedy (?) match
      name = canonical_name.gsub( /\(.+?\)/, '' ).strip
      names << name
    end

    ### todo/fix:
    ##  auto-add alt name with dots stripped - why? why not?
    ##    e.g.  D.C. United    => DC United
    ##    e.g.  Liverpool F.C. => Liverpool FC
    ##    e.g.  St. Albin       => St Albin etc.
    ##    e.g.  1. FC Köln     => 1 FC Köln  -- make special case for 1. - why? why not?

    ##
    ## todo/fix:  unify mapping entries
    ##   always lowercase !!!!  (case insensitive)
    ##   always strip (2011-) !!!
    ##   always strip dots (e.g. St., F.C, etc.)


    names = names.uniq  ## remove duplicates - todo/fix: warn about duplicates - why? why not?

    ## note: remove from alt_names if canonical name (mapping 1:1)
    ##                            or if empty
    alt_names = names.select {|name| (name.empty? || name == canonical_name) ? false : true }

    ## todo: add country (code) too!!!
    rec = SportDb::Struct::Team.create(
                                    name:      canonical_name,
                                    city:      city,     ## note: team_city is optional for now (might be nil!!!)
                                    alt_names: alt_names
                                  )
    ## pp rec
    recs << rec
  end
  recs
end  # method read
end  # class TeamReader


end ## module Import
end ## module SportDb
