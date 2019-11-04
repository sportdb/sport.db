# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_sync.rb


require 'helper'


class TestSync < MiniTest::Test

  def test_sync
    SportDb.connect( adapter: 'sqlite3', database: ':memory:' )
    SportDb.create_all   ## build schema

    ## turn on logging to console
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    at_rec  = SportDb::Import::Country.new( 'at',  'Austria', fifa: 'AUT' )
    eng_rec = SportDb::Import::Country.new( 'eng', 'England', fifa: 'ENG' )

    at    = SportDb::Sync::Country.find_or_create( at_rec )
    at2   = SportDb::Sync::Country.find_or_create( at_rec )

    eng   = SportDb::Sync::Country.find_or_create( eng_rec )
    eng2  = SportDb::Sync::Country.find_or_create( eng_rec )
  end  # method test_sync
end  # class TestSync
