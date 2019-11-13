# Notes

## Todos

todo/fix:  use config / configurations; remove all globals e.g.:
- COUNTRIES
- CLUBS
- LEAGUES !!!!!


fix clubs.find_by and clubs.find_by!

```
### todo/fix: move to clubs for sharing!!!!!!!
### use clubs.find_by!( name:, country: )

  def self.find_club( name, country )   ## todo/fix: add international or league flag?
    club = nil
    m = config.clubs.match_by( name: name, country: country )

    if m.nil?
      ## (re)try with second country - quick hacks for known leagues
      ##  todo/fix: add league flag to activate!!!
      m = config.clubs.match_by( name: name, country: config.countries['wal'])  if country.key == 'eng'
      m = config.clubs.match_by( name: name, country: config.countries['nir'])  if country.key == 'ie'
      m = config.clubs.match_by( name: name, country: config.countries['mc'])   if country.key == 'fr'
      m = config.clubs.match_by( name: name, country: config.countries['li'])   if country.key == 'ch'
      m = config.clubs.match_by( name: name, country: config.countries['ca'])   if country.key == 'us'
    end

    if m.nil?
      puts "** !!! ERROR !!! no match for club >#{name}<"
      exit 1
    elsif m.size > 1
      puts "** !!! ERROR !!! too many matches (#{m.size}) for club >#{name}<:"
      pp m
      exit 1
    else   # bingo; match - assume size == 1
      club = m[0]
    end

    club
  end



## yorobot / check_clubs

def find_club( name, country )   ## todo/fix: add international or league flag?
  club = nil
  m = CLUBS.match_by( name: name, country: country )

  if m.nil?
    ## (re)try with second country - quick hacks for known leagues
    ##  todo/fix: add league flag to activate!!!
    m = CLUBS.match_by( name: name, country: COUNTRIES['wal'])  if country.key == 'eng'
    m = CLUBS.match_by( name: name, country: COUNTRIES['nir'])  if country.key == 'ie'
    m = CLUBS.match_by( name: name, country: COUNTRIES['mc'])   if country.key == 'fr'
    m = CLUBS.match_by( name: name, country: COUNTRIES['li'])   if country.key == 'ch'
    m = CLUBS.match_by( name: name, country: COUNTRIES['ca'])   if country.key == 'us'
  end

  if m.nil?
    ## puts "** !!! WARN !!! no match for club >#{name}<"
  elsif m.size > 1
    puts "** !!! ERROR !!! too many matches (#{m.size}) for club >#{name}<:"
    pp m
    exit 1
  else   # bingo; match - assume size == 1
    club = m[0]
  end

  club
end
```

new - add season arg/para/filter!!!!!!!

```
require 'sportdb/formats'


## todo/check - add start arg too (shortcut for all season from start on) - why? why not?


season1 = '2011/2012'
season2 = ['2011/12', '2012-13', '2013/2014']

def norm_seasons( season_or_seasons )
    seasons = if season_or_seasons.is_a? String    ## wrap in array
                [season_or_seasons]
              else  ## assume it's an array already
                 season_or_seasons
              end

    seasons.map { |season| SeasonUtils.key( season ) }
end


season1n = norm_seasons( season1 )
season2n = norm_seasons( season2 )

pp season1
pp season1n

pp season2
pp season2n

pp season2n.include?( SeasonUtils.key( '2012/2013') )
pp season2n.include?( SeasonUtils.key( '2015/2016') )
```
