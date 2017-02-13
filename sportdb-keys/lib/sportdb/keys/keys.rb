# encoding: utf-8

###
##  add all known repos settings from build scripts ???
#
##   or sportdb/data  ??


module SportDb


module EventKeys
  # use constants for known keys; lets us define aliases (if things change)
  AT_2011_12     = 'at.2011/12'
  AT_2012_13     = 'at.2012/13'
  AT_2013_14     = 'at.2013/14'
  AT_2014_15     = 'at.2014/15'

  AT_CUP_2012_13 = 'at.cup.2012/13'
  AT_CUP_2013_14 = 'at.cup.2013/14'
  AT_CUP_2014_15 = 'at.cup.2014/15'

  CL_2012_13     = 'cl.2012/13'
  CL_2013_14     = 'cl.2013/14'
  CL_2013_14     = 'cl.2014/15'

  EURO_2008      = 'euro.2008'
  EURO_2012      = 'euro.2012'
  EURO_2012      = 'euro.2016'

  WORLD_2010     = 'world.2010'
  WORLD_2014     = 'world.2014'

  WORLD_QUALI_EUROPE_2014  = 'world.quali.europe.2014'
  WORLD_QUALI_AMERICA_2014 = 'world.quali.america.2014'

  ##################################################################
  # NB: see github/openfootball (leagues.txt) for keys in use
end  # module EventKeys


### todo: use module alias Key ?? why?? why not??

module Keys
  include EventKeys
end

end # module SportDb
