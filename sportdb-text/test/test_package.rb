# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_package.rb


require 'helper'

class TestPackage < MiniTest::Test


  def test_glob
    root_path = "#{SportDb::Import.config.test_data_dir}/packages/test-levels"

    ## check should NOT include /1980s  (with s)  only /1980 /1981 etc.
    season_patterns = CsvPackage::SEASON_PATTERNS

    season_paths = Dir.glob( "#{root_path}/**/{#{season_patterns.join(',')}}" )

    pp season_paths

    assert true   # assume ok if we get here
  end

  def test_package
    path = "#{SportDb::Import.config.test_data_dir}/packages/test-levels"

    pack = CsvPackage.new( path )

    pp pack.find_entries_by_season

    pp pack.find_entries_by_season_n_division

    pp pack.find_entries_by_code_n_season_n_division

    assert true   # assume ok if we get here
  end

end # class TestPackage
