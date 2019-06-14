# encoding: utf-8

module SportDb
  module Import


class LeagueConfig   ## use LeagueInfo or LeagueMap or LeagueHash or similar

def initialize

  ## just use leagues without latest for latest - why? why not?
  @leagues_latest = {
   'es' => { '1' => 'liga',  # spanish liga 1
             '2' => 'liga2',  # spanish liga 2
           },
   'it' => { '1' => 'seriea',  # italian serie a
             '2' => 'serieb',  # italian serie b
           },
   'de' => { '1' => 'bundesliga',  # german bundesliga
             '2' => 'bundesliga2', # german 2. bundesliga
           },
  'nl'  =>  { '1' => 'eredivisie' },   # dutch eredivisie
  'be'  =>  { '1' => 'proleague' },    # belgian pro league
  'pt'  =>  { '1' => 'liga' },         # portugese Primeira Liga
  'tr'  =>  { '1' => 'superlig' },     # turkish Süper Lig

#  note: eng now read from txt
#     'eng'  => { '1' => 'premierleague',  # english premier league
#                 '2' => 'championship',  # english championship league
#                 '3' => 'league1',  # english league 1
#               },
  }

  ## change history to past or changes/changelog something - why? why not?
  @leagues_history = {

#  note: eng now read from txt
#    'eng' => {
#               ## until (including) 2003-04 season
#               '2003-04' => { '1' => 'premierleague', # english premier league
#                              '2' => 'division1',     # english division 1
#                            },
#               ## until (including) 1991-92} season
#               '1991-92' => { '1' => 'division1', # english division 1
#                              '2' => 'division2', # english division 2
#                            }
#             }
  }

  pp @leagues_latest
  pp @leagues_history

  %w(eng sco fr gr).each do |country|
    hash = LeagueReader.from_file( "#{Import.data_dir}/leagues/#{country}.txt" )
    pp hash

    hash.each do |season,league_hash|
      if season == '*'  ## assume latest / default season
        @leagues_latest[ country ] = league_hash
      else
        @leagues_history[ country ] ||= {}
        @leagues_history[ country ][ season ]  = league_hash
      end
    end
  end

  pp @leagues_latest
  pp @leagues_history
end



def basename( league, country:, season: )
  ## todo/check: rename league: to key: - why? why not?

  if country.include?( '-' )  ## assume package name e.g. eng-england etc.
    ## cut off country code from package name
    cc = country.split( '-' )[0]   # use first part
  else
    cc = country
  end

  if season
    puts "  checking season >#{season}<"
    ## check history if season is provided / supplied / known
    history = @leagues_history[ cc ]
    if history
       season_start_year = SeasonUtils.start_year( season ).to_i
       ##
       ##  todo: sorty season keys - why? why not?  -- assume reverse chronological order for now
       history.keys.reverse.each do |key|
          history_season_start_year = SeasonUtils.start_year( key ).to_i
          puts "  #{season_start_year} <= #{history_season_start_year} - #{season_start_year <= history_season_start_year}"
          if season_start_year <= history_season_start_year
            result = history[ key ][ league ]
            if result
              return "#{league}-#{result}"
            else
              return nil
            end
          end
       end
    end
  end

  latest  = @leagues_latest[ cc ]
  if latest
     result = latest[ league ]
     return "#{league}-#{result}"   if result
  end

  nil
end # method basename
end # class LeagueConfig


end ## module Import
end ## module SportDb
