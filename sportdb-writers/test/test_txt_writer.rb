###
#  to run use
#     ruby test/test_txt_writer.rb


require_relative 'helper'


class TestTxtWriter < Minitest::Test

  TxtMatchWriter = SportDb::TxtMatchWriter
  CsvMatchParser = SportDb::CsvMatchParser

  STAGE_DIR = '/sports/cache.api.fbdat' 

  def test_eng
     matches = CsvMatchParser.read( "#{STAGE_DIR}/2024-25/eng.1.csv" )

     puts
     pp matches[0]
     puts "#{matches.size} matches"

     league_name  = 'English Premier League'
     season_key   = '2024/25'

     path = './tmp/pl.txt'
     TxtMatchWriter.write( path, matches,
                             name: "#{league_name} #{season_key}" )
  end

  def test_es
    matches = CsvMatchParser.read( "#{STAGE_DIR}/2024-25/es.1.csv" )

    puts
    pp matches[0]
    puts "#{matches.size} matches"


    league_name  = 'Primera División de España'
    season_key   = '2024/25'

    path = './tmp/liga.txt'
    TxtMatchWriter.write( path, matches,
                            name: "#{league_name} #{season_key}" )
 end

 def test_it
  matches = CsvMatchParser.read( "#{STAGE_DIR}/2024-25/it.1.csv" )

  puts
  pp matches[0]
  puts "#{matches.size} matches"


  league_name  = 'Italian Serie A'
  season_key   = '2024/25'

  path = './tmp/seriea.txt'
  TxtMatchWriter.write( path, matches,
                          name: "#{league_name} #{season_key}" )
 end


end # class TestTxtWriter
