# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_package.rb


require 'helper'

class TestPackage < MiniTest::Test


  def test_glob
    root_path = "#{SportDb::Import.test_data_dir}/packages/test-levels"

## check should NOT include /1980s  (with s)  only /1980 /1981 etc.
season_patterns = [
     '[0-9][0-9][0-9][0-9]-[0-9][0-9]',  ## e.g. /1998-99/
     '[0-9][0-9][0-9][0-9]'              ## e.g  /1999/  - note: will NOT include /1990s etc.
]


season_paths = Dir.glob( "#{root_path}/**/{#{season_patterns.join(',')}}" )

pp season_paths

      assert true   # assume ok if we get here
   end

  def test_package
    path = "#{SportDb::Import.test_data_dir}/packages/test-levels"

    pack = CsvPackage.new( path )

    pp pack.find_entries_by_season

    assert true   # assume ok if we get here
  end

end # class TestPackage
