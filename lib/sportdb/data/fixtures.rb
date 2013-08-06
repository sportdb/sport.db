# encoding: utf-8

def find_football_db_path_from_gemfile_gitref!
  puts "[debug] find_football_db_path..."
  puts "load path:"
  pp $LOAD_PATH
  
  candidates = []
  $LOAD_PATH.each do |path|
    if path =~ /\/(football\.db-[a-z0-9]+)|(football\.db)\//
      candidates << path.dup
    end
  end
  
  puts "found candidates:"
  pp candidates
  
  ## cut-off everything after /football.db
  # e.g. lib/ruby/gems/1.9.1/bundler/gems/football.db-38279c414449/lib becomes
  #      lib/ruby/gems/1.9.1/bundler/gems/football.db-38279c414449
  
  cand = candidates[0]
  
  puts "cand before: #{cand}"
  
  ## nb: *? is non-greedy many operator
  
  ## todo: why not just cut off trailing /lib - is it good enough??
  # it's easier
  
  regex = /(\/football\.db.*?)(\/.*)/
  cand = cand.sub( regex ) do |_|
    puts "cutting off >>#{$2}<<"
    $1
  end
  
  puts "cand after: #{cand}"
  
  ## todo:exit with error if not found!!!
  
  cand
end



module SportDb
  
  module Fixtures   # use shortcut/alias Fx?
  
  ## todo/ check: remove _FIXTURES and use module namespace instead?
  
  
  SEASONS = [
    'seasons'
  ]
  
  LEAGUES = [
    'leagues',
    'leagues_club'
  ]
  
  ## todo/check: put teams into its own module/namespace (remove _TEAMS?)
  EUROPE_TEAMS = [
    'europe/teams'
  ]

  ## NB: copa america requires jpn as team invitee (from asia)
  AMERICA_TEAMS = [
    'world/teams',
    'america/teams'
  ]
  
  WORLD_TEAMS = [
    'world/teams',
    'america/teams',
    'europe/teams'
  ]

  AT_TEAMS = [ 'at/teams', 'at/teams2' ]
  DE_TEAMS = [ 'de/teams' ]
  EN_TEAMS = [ 'en/teams' ]
  ES_TEAMS = [ 'es/teams' ]
  FR_TEAMS = [ 'fr/teams' ]
  IT_TEAMS = [ 'it/teams' ]
  RO_TEAMS = [ 'ro/teams' ]

  CLUB_EUROPE_TEAMS =
    AT_TEAMS +
    DE_TEAMS +
    EN_TEAMS +
    ES_TEAMS +
    FR_TEAMS +
    IT_TEAMS + 
    RO_TEAMS +
   [
    'club/europe/teams'
   ]
  
  
  AR_TEAMS = [ 'ar/teams' ]
  BR_TEAMS = [ 'br/teams' ]
  MX_TEAMS = [ 'mx/teams' ]
  
  CLUB_AMERICA_TEAMS = 
    AR_TEAMS +
    BR_TEAMS +
    MX_TEAMS +
  [
    'america/teams_c',
    'america/teams_n',
    'america/teams_s',
  ]
  
  AR_FIXTURES = []

  ### todo: ? get event_key automatically from event_reader ?? why? why not??
  BR_FIXTURES = [
    'br/2013/cb'
  ]

  MX_FIXTURES = [
    'mx/2012/apertura',
    'mx/2013/clausura'
  ]


  AT_FIXTURES = [
    'at/2011_12/bl',
    'at/2011_12/cup',
    'at/2012_13/bl',
    'at/2012_13/cup'
  ]
  
  DE_FIXTURES = [
    'de/2012_13/bl'
  ]
  
  EN_FIXTURES = [
    'en/2012_13/pl'
  ]
  
  RO_FIXTURES = [
    'ro/2012_13/l1'
  ]
  
  
  EUROPE_FIXTURES = [
    'euro-cup!/2008/euro',
    'euro-cup!/2012/euro'
  ]
    
  AMERICA_FIXTURES = [
    'america/2011/copa',
    'america/2011/gold',
    'america/2013/gold',
    'america/2015/copa'
  ]
  
  WORLD_FIXTURES = [
    'world/2009/conf',
    'world/2010/cup',
    'world/2014/quali_america',
    'world/2014/quali_europe_c',
    'world/2014/quali_europe',
    'world/2014/cup'
  ]
  
  CLUB_EUROPE_FIXTURES = [
    'club/europe/2011_12/cl',
    'club/europe/2011_12/el',
    'club/europe/2012_13/cl',
    'club/europe/2012_13/el'
  ]
  
  CLUB_AMERICA_FIXTURES = [
    'club/america/2011_12/cl',
    'club/america/2012/libertadores',
    'club/america/2012/sud',
    'club/america/2012_13/cl',
    'club/america/2013/libertadores'
  ]
  
  def self.all
    SEASONS + 
    LEAGUES +
    CLUB_AMERICA_TEAMS +
    AR_FIXTURES +
    BR_FIXTURES +
    MX_FIXTURES +
    CLUB_AMERICA_FIXTURES +
    CLUB_EUROPE_TEAMS +
    AT_FIXTURES +
    DE_FIXTURES +
    EN_FIXTURES +
    RO_FIXTURES +
    CLUB_EUROPE_FIXTURES +
    WORLD_TEAMS +
    AMERICA_FIXTURES +
    EUROPE_FIXTURES +
    WORLD_FIXTURES
  end  # method all

  end # module Fixtures
  
end # module SportDb