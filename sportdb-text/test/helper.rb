## $:.unshift(File.dirname(__FILE__))

## minitest setup

require 'minitest/autorun'


## our own code

require 'sportdb/text'


SportDb::Import.config.clubs_dir = '../../../openfootball/clubs'

## share test datasets between gems - do NOT include in gem itself
SportDb::Import.config.test_data_dir = '../datasets'
