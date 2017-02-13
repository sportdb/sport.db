# encoding: utf-8

module SportDb
  module FixtureHelpers


  def find_scores!( line, opts={} )
    # note: always call after find_dates !!!
    #  scores match date-like patterns!!  e.g. 10-11  or 10:00 etc.
    #   -- note: score might have two digits too

    finder = ScoresFinder.new
    finder.find!( line, opts )
  end

  end # module FixtureHelpers
end # module SportDb
