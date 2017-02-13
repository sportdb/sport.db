# encoding: utf-8

module SportDb
  module FixtureHelpers

  def is_goals?( line )
    # check if is goals line
    #  e.g. looks like
    #   Neymar 29', 71' (pen.) Oscar 90+1';  Marcelo 11' (o.g.)
    #  check for
    #    <space>90'  or
    #    <space>90+1'

    line =~ /[ ](\d{1,3}\+)?\d{1,3}'/
  end


  end # module FixtureHelpers
end # module SportDb

