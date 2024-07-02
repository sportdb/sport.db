
module Sports


class League
  attr_reader   :key, :name, :country, :intl
  attr_accessor :alt_names


  def initialize( key:, name:, alt_names: [],
                  country: nil, intl: false, clubs: true )
    @key            = key
    @name           = name
    @alt_names      = alt_names
 
    @country        = country
    @intl           = intl
    @clubs          = clubs
  end

  def intl?()      @intl == true; end
  def national?()  @intl == false; end
  alias_method   :domestic?, :national?

  def clubs?()            @clubs == true; end
  def national_teams?()   @clubs == false; end
  alias_method   :club?,          :clubs?
  alias_method   :national_team?, :national_teams?

=begin 
 @alt_names=[],
  @clubs=true,
  @country=<Country: at - Austria (AUT)|Österreich [de], fifa|uefa)>,
  @intl=false,
  @key="at.1",
  @name="Bundesliga">, 
=end

  def pretty_print( printer ) 
    buf = String.new
    buf << "<League"
    buf << " INTL"   if @intl
    buf <<   if @clubs 
                 " CLUBS" 
             else 
                 " NATIONAL TEAMS"
             end  
    buf << ": #{@key} - #{@name}"
    buf << "|#{@alt_names.join('|')}"  if @alt_names && !@alt_names.empty?
    buf << ", #{@country.name} (#{@country.code})"     if @country
    buf << ">"

    printer.text( buf ) 
  end




end   # class League

end   # module Sports
