require 'pp'
require 'date'
require 'time'


###
# our own code
require_relative 'score-formats/version' # let version always go first

## todo/fix: make logging class configurable - lets you use logutils etc.
module ScoreFormats
  module Logging
    def logger() @logger ||= Logger.new; end

    class Logger   ## for now use quick "dummy" logger to
      def debug( msg ) puts "[debug] #{msg}"; end
    end # class Logger
  end  # module Logging
end # module ScoreFormats



require_relative 'score-formats/score'
require_relative 'score-formats/formats'
require_relative 'score-formats/parser'
require_relative 'score-formats/printer'



module ScoreFormats
  def self.lang
    @@lang ||= :en            ## defaults to english (:en)
  end
  def self.lang=( value )
    @@lang = value.to_sym    ## note: make sure lang is always a symbol for now (NOT a string)
    @@lang      ## todo/check: remove  =() method always returns passed in value? double check
  end

  def self.parser( lang: )  ## find parser
    lang = lang.to_sym  ## note: make sure lang is always a symbol for now (NOT a string)

    ## note: cache all "built-in" lang versions (e.g. formats == nil)
    @@parser ||= {}
    @@parser[ lang ] ||= ScoreParser.new( lang: lang )
  end

  def self.parse( line, lang: ScoreFormats.lang )
    parser( lang: lang ).parse( line )
  end

  def self.find!( line, lang: ScoreFormats.lang )
    parser( lang: lang ).find!( line )
  end
end



##
# add more convenience / shortcut helpers / named ctors to score class itself

class Score
  def self.parse( line, lang: ScoreFormats.lang )
    ScoreFormats.parse( line, lang: lang )
  end

  def self.find!( line, lang: ScoreFormats.lang )
    ScoreFormats.find!( line, lang: lang )
  end
end



puts ScoreFormats.banner   # say hello
