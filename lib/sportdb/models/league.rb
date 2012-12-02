module SportDB::Models


class League < ActiveRecord::Base
  
  ## leagues also used for conferences, world series, cups, etc.
  #
  ## league (or cup/conference/series/etc.) + season (or year) = event
  
  has_many :events
  has_many :seasons, :through => :events
  
  belongs_to :country, :class_name => 'WorldDB::Models::Country', :foreign_key => 'country_id'


  def self.create_from_ary!( leagues, more_values={} )
    leagues.each do |values|
      
      ## key & title required
      attr = {
        key:   values[0],
        title: values[1]
      }
      
      attr = attr.merge( more_values )
      
      ## check for optional values
      values[2..-1].each do |value|
        if value.is_a? Country
          attr[ :country_id ] = value.id
        else
          # issue warning: unknown type for value
        end
      end

      League.create!( attr )
    end # each league
  end

end  # class League


end # module SportDB::Models
