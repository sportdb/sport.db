# encoding: utf-8

require 'sportdb/config'
require 'sportdb/models'   ## add sql database support


# our own code
require 'sportdb/calc/version'    # let version always go first
require 'sportdb/calc/standing'



## say hello
puts SportDb::Module::Calc.banner
