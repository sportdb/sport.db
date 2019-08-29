## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code

require 'sportdb/text'


SportDb::Import.config.clubs_dir = '../../../openfootball/clubs'

## share test datasets between gems - do NOT include in gem itself
SportDb::Test.data_dir = '../test'
