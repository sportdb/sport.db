## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code
require 'sportdb/import'




SportDb.connect( adapter:  'sqlite3', database: ':memory:' )
SportDb.create_all   ## build schema

## turn on logging to console
## ActiveRecord::Base.logger = Logger.new(STDOUT)

## use "external" clubs mappings for now - gemify later - why? why not?
SportDb::Import.config.clubs_dir     = '../../../openfootball/clubs'


## share test datasets between gems - do NOT include in gem itself
SportDb::Import.config.test_data_dir = '../datasets'
