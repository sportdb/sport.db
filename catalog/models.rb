module CatalogDb
module Model
  
##
# setup for multiple database connection support
class CatalogRecord <   ActiveRecord::Base  # ApplicationRecord
  self.abstract_class = true
end

class Country < CatalogRecord
    has_many :country_codes
    has_many :country_names
    
    has_many :clubs
end # class Country

class CountryCode < CatalogRecord
    belongs_to  :country
end # class CountryCode

class CountryName < CatalogRecord
    belongs_to  :country
end # class CountryName


class Club < CatalogRecord
    belongs_to  :country

    has_many :club_names
end

class ClubName  < CatalogRecord
    belongs_to :club
end

end # module Model
end # module CatalogDb
  