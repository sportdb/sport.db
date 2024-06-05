module CatalogDb
 module PersonDb

module Model
  
##
# setup for multiple database connection support
class PersonRecord <  ActiveRecord::Base  # ApplicationRecord
  self.abstract_class = true
end

class Person < PersonRecord
    self.table_name = 'persons'   ## use persons (NOT people) for now

    has_many :person_names
end # class Person

class PersonName < PersonRecord
    belongs_to  :person
end # class CountryName


end # module Model
end # module PersonDb
end # module CatalogDb
  