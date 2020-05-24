module SportDb
  module Model

class Badge < ActiveRecord::Base

  belongs_to :team
  belongs_to :league
  belongs_to :season

end  # class Badge


  end # module Model
end # module SportDb
