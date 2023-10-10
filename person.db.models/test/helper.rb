# encoding: utf-8

## $:.unshift(File.dirname(__FILE__))

## minitest setup
require 'minitest/autorun'

# our own code

require 'persondb/models'


################
# shortcuts
Country = WorldDb::Model::Country
State   = WorldDb::Model::State
City    = WorldDb::Model::City

## todo: get all models aliases (e.g. from console script)

Person        = PersonDb::Model::Person
PersonReader  = PersonDb::PersonReader


############
# setup
PersonDb.setup_in_memory_db

