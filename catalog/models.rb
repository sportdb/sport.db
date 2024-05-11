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
end # class Country

class CountryCode < CatalogRecord
    belongs_to  :country
end # class CountryCode

class CountryName < CatalogRecord
    belongs_to  :country
end # class CountryName

end # module Model
end # module CatalogDb
  