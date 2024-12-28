###
#  to run use
#     ruby test/test_txt_writer.rb


require_relative 'helper'


class TestTxtWriter < Minitest::Test

  TxtMatchWriter = SportDb::TxtMatchWriter
  CsvMatchParser = SportDb::CsvMatchParser

  STAGE_DIR = '../../../cache.api.fbdat' 

  def test_eng
     matches = CsvMatchParser.read( "#{STAGE_DIR}/2023-24/eng.1.csv" )

     puts
     pp matches[0]
     puts "#{matches.size} matches"

     league_name  = 'English Premier League'
     season_key   = '2023/24'

     path = './tmp/pl.txt'
     TxtMatchWriter.write( path, matches,
                             name: "#{league_name} #{season_key}" )
  end

  def test_es
    matches = CsvMatchParser.read( "#{STAGE_DIR}/2023-24/es.1.csv" )

    puts
    pp matches[0]
    puts "#{matches.size} matches"


    league_name  = 'Primera División de España'
    season_key   = '2023/24'

    path = './tmp/liga.txt'
    TxtMatchWriter.write( path, matches,
                            name: "#{league_name} #{season_key}" )
 end

 def test_it
  matches = CsvMatchParser.read( "#{STAGE_DIR}/2023-24/it.1.csv" )

  puts
  pp matches[0]
  puts "#{matches.size} matches"


  league_name  = 'Italian Serie A'
  season_key   = '2023/24'

  path = './tmp/seriea.txt'
  TxtMatchWriter.write( path, matches,
                          name: "#{league_name} #{season_key}" )
 end


  #####
  #  note: fix sort order e.g. cover
  #
  # 17^ Giornata
  # [Mer. 18.12.]
  #  UC Sampdoria             1-2  Juventus
  #
  # 7^ Giornata
  # [Mer. 18.12.]
  #  Brescia                  0-2  US Sassuolo Calcio
  #
  # 17^ Giornata
  # [Ven. 20.12.]
  #  ACF Fiorentina           1-4  AS Roma

end # class TestTxtWriter
