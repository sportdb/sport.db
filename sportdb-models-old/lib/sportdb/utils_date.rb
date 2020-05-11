# encoding: utf-8

module SportDb
  module FixtureHelpers

  def is_postponed?( line )
    # check if line include postponed marker e.g. =>
    line =~ /=>/
  end


  def find_date!( line, opts={} )
    ## NB: lets us pass in start_at/end_at date (for event)
    #   for auto-complete year

    # extract date from line
    # and return it
    # NB: side effect - removes date from line string
    
    finder = DateFinder.new
    finder.find!( line, opts )
  end

  end # module FixtureHelpers
end # module SportDb

