#####
## quick match reader for datafiles with league outlines

module SportDb
class QuickMatchReader

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt )
  end

  def self.parse( txt )
    new( txt ).parse
  end


  include Logging

  def initialize( txt )
    @txt = txt
  end

  def parse
    data = {}   # return data hash with leagues
                #    and seasons
                #   for now merge stage into matches

    secs = QuickLeagueOutlineReader.parse( @txt )
    pp secs

    secs.each do |sec|   ## sec(tion)s
      season = Season.parse( sec[:season] )   ## convert (str) to season obj!!!
      league = sec[:league]
      stage  = sec[:stage]
      lines  = sec[:lines]

      start =  if season.year?
                  Date.new( season.start_year, 1, 1 )
                else
                  Date.new( season.start_year, 7, 1 )
                end


      parser = MatchParser.new( lines,
                                start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)

      auto_conf_teams,  matches, rounds, groups = parser.parse

      puts ">>> #{auto_conf_teams.size} teams:"
      pp auto_conf_teams
      puts ">>> #{matches.size} matches:"
      ## pp matches
      puts ">>> #{rounds.size} rounds:"
      pp rounds
      puts ">>> #{groups.size} groups:"
      pp groups

      ## note: pass along stage (if present): stage  - optional from heading!!!!
      if stage
        matches.each do |match|
          match = match.update( stage: stage )
        end
      end

      data[ league ] ||= {}
      data[ league ][ season.key ] ||= []

      data[ league ][ season.key ] += matches
      ## note - skip teams, rounds, and groups for now
    end

## check - only one league and one season
##             allowed in quick style


    leagues = data.keys
    if leagues.size != 1
        puts "!! (QUICK) PARSE ERROR - expected one league only; got #{leagues.size}:"
        pp leagues
        exit 1
    end

    seasons = data[ leagues[0] ].keys
    if seasons.size != 1
        puts "!! (QUICK) PARSE ERROR - expected one #{leagues[0]} season only; got #{seasons.size}:"
        pp seasons
        exit 1
    end

    data[ leagues[0] ][ seasons[0] ]
  end # method parse

end # class QuickMatchReader
end # module SportDb
