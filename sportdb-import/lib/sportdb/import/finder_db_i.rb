# encoding: utf-8



module SportDb
  module Importer

class Country
    ## built-in countries for (quick starter) auto-add
    COUNTRIES = {    ## rename to AUTO or BUILTIN_COUNTRIES or QUICK_COUNTRIES - why? why not?
      ## british isles
      eng: ['England',     'ENG'],     ## title/name, code
      sco: ['Scotland',    'SCO'],
      ie:  ['Ireland',     'IRL'],

      ## central europe
      at:  ['Austria',      'AUT'],
      de:  ['Germany',      'GER'],   ## use fifa code or iso? - using fifa for now
      ch:  ['Switzerland',  'SWZ'],
      pl:  ['Poland',       'POL'],

      ## western europe
      fr:  ['France',      'FRA'],
      es:  ['Spain',       'ESP'],

      ## northern europe / skandinavia
      dk:  ['Denmark',      'DNK'],
      fi:  ['Finland',      'FIN'],
      no:  ['Norway',       'NOR'],
      se:  ['Sweden',       'SWE'],

      ## eastern europe
      ro:  ['Romania',      'ROU'],
      ru:  ['Russia',       'RUS'],

      ## north america
      us:  ['United States', 'USA'],
      mx:  ['Mexico',        'MEX'],

      ## south america
      ar:  ['Argentina',   'ARG'],
      br:  ['Brazil',      'BRA'],

      ## asia
      cn:  ['China',       'CHN'],
      jp:  ['Japan',       'JPN'],
    }

    ### todo/fix:
    ##  add ALTERNATE / ALTERNATIVE COUNTRY KEYS!!!!
    ##   e.g. d => de, a => at, en => eng, etc.
    ##   plus  add all fifa codes too   aut => at, etc.

def self.find_or_create_builtin!( key )   ## e.g. key = 'eng' or 'de' etc.
   key = key.to_s   ## allow passing in of symbol (e.g. :fr instead of 'fr')

   country = WorldDb::Model::Country.find_by( key: key )
   if country.nil?
     ### check quick built-tin auto-add country data
     data = COUNTRIES[ key.to_sym ]
     if data
       name, code = data

       country = WorldDb::Model::Country.create!(
          key:  key,
          name: name,
          code: code,
          area: 1,
          pop:  1
       )
     else
       puts "** unknown country for key >#{key}<; sorry - add to COUNTRIES table"
       exit 1
     end
   end
   country
end

def self.find!( key )   ## e.g. key = 'eng' or 'de' etc.
   rec = find( key )
   if rec.nil?
       puts "** unknown country for key >#{key}<; sorry - add to COUNTRIES table"
       exit 1
   end
   rec
end
end # class Country




### add season
class Season

def self.find_or_create_builtin( key )  ## e.g. key = '2017-18'

  ## note:  "normalize" season key
  ##   always use 2017/18  (and not 2017-18 or 2017-2018 or 2017/2018)
  ## 1) change 2017-18 to 2017/18
  key = key.tr( '-', '/' )
  ## 2) check for 2017/2018 - change to 2017/18
  if key.length == 9
    key = "#{key[0..3]}/#{key[7..8]}"
  end

  season = SportDb::Model::Season.find_by( key: key )
  if season.nil?
     season = SportDb::Model::Season.create!(
       key:   key,
       title: key
     )
  end
  pp season
  season
end
end # class Season



class League
## built-in countries for (quick starter) auto-add
LEAGUES = {    ## rename to AUTO or BUILTIN_LEAGUES or QUICK_LEAGUES  - why? why not?
  ## en:  'English Premier League',    ## use eng why? why not?
  eng: 'English Premier League',    ## use en why? why not?
  sco: 'Scottish Premiership',
  fr:  'Ligue 1',
  at:  'Österr. Bundesliga',
  de:  '1. Bundesliga',
  'de.2': '2. Bundesliga',
}


def self.find_or_create( key, name: )   ## use title and not name - why? why not?
   rec = find( key )
   if rec.nil?
     rec = SportDb::Model::League.create!(
        key:   key,
        title: name,  # e.g. 'English Premier League'
     )
   end
   rec
end

def self.find_or_create_builtin!( key )  ## e.g. key = 'eng' or 'eng.2' etc.
  ##  en,    English Premier League
  league = SportDb::Model::League.find_by( key: key )
  if league.nil?
     ### check quick built-in auto-add league data
     data = LEAGUES[ key.to_sym ]
     if data
       name = data
       league = SportDb::Model::League.create!(
                   key:   key,
                   title: name,  # e.g. 'English Premier League'
                )
     else
       puts "** unknown league for key >#{key}<; sorry - add to LEAGUES table"
       exit 1
     end
  end
  league
end


### add league
def self.find!( key )  ## e.g. key = 'en' or 'en.2' etc.
  ##  en,    English Premier League
  rec = find( key )
  if rec.nil?
    puts "** unknown league for key >#{key}<; sorry - add to LEAGUES table"
    exit 1
  end
  rec
end
end # class League


end # module Importer
end # module SportDb
