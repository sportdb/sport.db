# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_package.rb


require 'helper'

class TestPackage < MiniTest::Test

  AUSTRIA_DIR     = '../../../openfootball/austria'
  AUSTRIA_CSV_DIR = '../../../footballcsv/austria'

  ENGLAND_DIR     = '../../../openfootball/england'
  ENGLAND_CSV_DIR = '../../../footballcsv/england'


  def test_match_by

    [ AUSTRIA_CSV_DIR,
      ENGLAND_CSV_DIR,
      "#{SportDb::Test.data_dir}/packages/test-levels",
    ].each do |path|
      puts
      puts "match (csv) in #{path}:"
      pack = SportDb::Package.new( path )
      pp pack.match_by_season_dir( format: 'csv' )
      puts "---"
      pp pack.match_by_season( format: 'csv' )
    end

    [ AUSTRIA_DIR,
      ENGLAND_DIR,
      "#{SportDb::Test.data_dir}/packages/test-levels",
    ].each do |path|
      puts
      puts "match (txt) in #{path}:"
      pack = SportDb::Package.new( path )
      pp pack.match_by_season_dir
      puts "---"
      pp pack.match_by_season( start: '2000' )   ## note: try with start season filter!!
    end
  end
end # class TestPackage
