#######
## note: uses SportDb::Model namespace by design !!!
##

module SportDb
  module Model


class Run < ActiveRecord::Base

  belongs_to :race

end  # class Run


  end # module Model
end # module SportDb

