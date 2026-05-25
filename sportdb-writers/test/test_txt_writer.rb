###
#  to run use
#     ruby test/test_txt_writer.rb


require_relative 'helper'


class TestTxtWriter < Minitest::Test

  TxtMatchWriter = SportDb::TxtMatchWriter
  CsvMatchParser = SportDb::CsvMatchParser

  STAGE_DIR = '/sports/cache.api.fbdat'

  def test_eng
     matches = CsvMatchParser.read( "#{STAGE_DIR}/2025-26/eng.1.csv" )

     puts
     pp matches[0]
     puts "#{matches.size} matches"

     league_name  = 'England | Premier League'
     season_key   = '2025/26'

     path = './tmp/pl.txt'
     TxtMatchWriter.write_v2( path, matches,
                             name: "#{league_name} #{season_key}" )
  end

 def test_eng2
     matches = CsvMatchParser.read( "#{STAGE_DIR}/2025-26/eng.2.csv" )

     puts
     pp matches[0]
     puts "#{matches.size} matches"

     league_name  = 'England | Championship'
     season_key   = '2025/26'

     path = './tmp/championship.txt'
     TxtMatchWriter.write_v2( path, matches,
                             name: "#{league_name} #{season_key}" )
  end



  def test_es
    matches = CsvMatchParser.read( "#{STAGE_DIR}/2025-26/es.1.csv" )

    puts
    pp matches[0]
    puts "#{matches.size} matches"


    league_name  = 'Spain | Primera División'
    season_key   = '2025/26'

    path = './tmp/liga.txt'
    TxtMatchWriter.write_v2( path, matches,
                             name: "#{league_name} #{season_key}" )
 end

 def test_it
  matches = CsvMatchParser.read( "#{STAGE_DIR}/2025-26/it.1.csv" )

  puts
  pp matches[0]
  puts "#{matches.size} matches"


  league_name  = 'Italy | Serie A'
  season_key   = '2025/26'

  path = './tmp/seriea.txt'
  TxtMatchWriter.write_v2( path, matches,
                          name: "#{league_name} #{season_key}" )
 end


end # class TestTxtWriter
