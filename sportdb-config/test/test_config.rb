# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_config.rb


require 'helper'

class TestConfig < MiniTest::Test

  def match( txt ) SportDb::Import::Configuration::CLUBS_REGEX.match( txt ); end

  def test_find_clubs
      assert match( 'de.clubs.txt' )
      assert match( 'deutschland/de.clubs.txt' )
      assert match( 'europe/de-deutschland/clubs.txt' )
      assert match( 'de-deutschland/clubs.txt' )
      assert match( 'clubs.txt' )
      assert match( 'deutschland/clubs.txt' )
  end

end # class TestConfig
