module CatalogDb
module Model
  
##
# setup for multiple database connection support
class CatalogRecord <   ActiveRecord::Base  # ApplicationRecord
  self.abstract_class = true
end

class Country < CatalogRecord
    has_many :country_codes, foreign_key: 'key', primary_key: 'key' 
    has_many :country_names, foreign_key: 'key', primary_key: 'key'
    
    has_many :clubs,   foreign_key: 'country_key', primary_key: 'key'
    has_many :leagues, foreign_key: 'country_key', primary_key: 'key'
end # class Country



class CountryCode < CatalogRecord
    belongs_to  :country,  foreign_key: 'key', primary_key: 'key'
end # class CountryCode

class CountryName < CatalogRecord
    belongs_to  :country, foreign_key: 'key', primary_key: 'key'
end # class CountryName



class Club < CatalogRecord
    belongs_to  :country, foreign_key: 'country_key', primary_key: 'key'

    has_many :club_names, foreign_key: 'key', primary_key: 'key'
end

class ClubName  < CatalogRecord
    belongs_to :club, foreign_key: 'key', primary_key: 'key'
end


class NationalTeam < CatalogRecord
    belongs_to  :country, foreign_key: 'country_key', primary_key: 'key'

    has_many :national_team_names, foreign_key: 'key', primary_key: 'key'
end

class NationalTeamName  < CatalogRecord
    belongs_to :club, foreign_key: 'key', primary_key: 'key'
end



class League < CatalogRecord
    belongs_to  :country, foreign_key: 'country_key', primary_key: 'key'

    has_many :league_names, foreign_key: 'key', primary_key: 'key'
end

class LeagueName  < CatalogRecord
    belongs_to :league, foreign_key: 'key', primary_key: 'key'
end


end # module Model
end # module CatalogDb
  