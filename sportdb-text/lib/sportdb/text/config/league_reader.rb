# encoding: utf-8


module SportDb
  module Import

class LeagueReader

def self.from_file( path )   ## use - rename to read_file - why? why not?
  txt = File.open( path, 'r:utf-8' ).read
  read( txt )
end



SEASON_REGEX = /\[
                (?<season>
                   \d{4}
                   (-\d{2,4})?
                )
               \]/x

def self.read( txt )
  hash = {}
  season = '*'   ## use '*' for default/latest season

  txt.each_line do |line|
    line = line.strip

    next if line.empty?
    next if line.start_with?( '#' )   ## skip comments too

    ## strip inline comments too
    line = line.sub( /#.*/, '' ).strip

    pp line


    if (m=line.match( SEASON_REGEX ))
        season = m[:season]
    else
      key_line, values_line = line.split( '=>' )
      values  = values_line.split( ',' )

      ## remove leading and trailing spaces
      key_line = key_line.strip
      values = values.map { |value| value.strip }
      pp values

      league_key      = key_line
      league_basename = values[0]

      hash[season] ||= {}
      hash[season][league_key] = league_basename
    end
  end
  hash
end # method read

end ## class LeagueReader



end ## module Import
end ## module SportDb
