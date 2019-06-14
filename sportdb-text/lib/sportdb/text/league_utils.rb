# encoding: utf-8


module LeagueHelper
  def basename( league, country:, season: nil )
     ## e.g. eng-england, 2011-12, 1  returns  1-premierleague
     ##
     ##  allow country code or (repo) package name
     ##    e.g. eng-england or eng
     ##         de-deutschland or de etc.

     leagues = SportDb::Import.config.leagues

     result = leagues.basename( league, country: country, season: season )

     ##
     # note: if no mapping / nothing found return league e.g. 1, 2, 3, 3a, 3b, cup(?), etc.
     result ? result : league
  end
end

module LeagueUtils
  extend LeagueHelper
end
