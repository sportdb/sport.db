###
#  to run use
#     ruby test/test_txt_writer_v2.rb


require_relative 'helper'


class TestTxtWriterV2 < Minitest::Test

  TxtMatchWriter = SportDb::TxtMatchWriter
  CsvMatchParser = SportDb::CsvMatchParser

  STAGE_DIR = '/sports/cache.wfb' 

  def _generate( league_name:, league_key:, seasons: )
    seasons.each do |season|
      season = Season( season )
      inpath = "#{STAGE_DIR}/#{season.to_path}/#{league_key}.csv"
      matches = CsvMatchParser.read( inpath )

      puts
      pp matches[0]
      puts "#{matches.size} matches"
 
      outpath = "./tmp/#{season.to_path}_#{league_key}.txt"
      TxtMatchWriter.write_v2( outpath, matches,
                               name: "#{league_name} #{season.key}" )
   end
 end


  def test_mx
    ## '2020/21'
    seasons      = [ '2023/24', '2024/25']
    _generate( league_name: 'Liga MX',
               league_key: 'mx.1', 
               seasons: seasons  )
  end

  def test_mls
    seasons      = ['2020', '2023', '2024', '2025']
    _generate( league_name: 'Major League Soccer',
               league_key: 'mls',
               seasons: seasons )
  end

  def test_at
    # '2023/24'
    seasons      = [ '2024/25']
    _generate( league_name: 'Austria | Bundesliga',
               league_key: 'at.1', 
               seasons: seasons  )
  end


end # class TestTxtWriterV2
