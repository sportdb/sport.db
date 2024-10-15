
module Sports


class LeaguePeriod
  attr_reader   :key, :name, :qname, :slug,
                :prev_name,  :start_season, :end_season
  def initialize( key:, name:, qname:, slug:,
                        prev_name: nil,
                        start_season: nil, end_season: nil )
    @key = key
    @name = name
    @qname = qname
    @slug = slug
    @prev_name = prev_name
    @start_season = start_season
    @end_season  = end_season
  end
end # class LeaguePeriod


class League
  attr_reader   :key, :name, :country, :intl
  attr_accessor :alt_names
  attr_accessor :periods


  def initialize( key:, name:, alt_names: [],
                  country: nil, intl: false, clubs: true )
    @key            = key
    @name           = name
    @alt_names      = alt_names

    @country        = country
    @intl           = intl
    @clubs          = clubs

    @periods        = []   ## change/rename to history - why? why not?
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

    if @alt_names && !@alt_names.empty?
      buf << "|"
      buf << @alt_names.join('|')
    end

    buf << ", #{@country.name} (#{@country.code})"     if @country

    if @periods && !@periods.empty?
      buf << ", "
      buf << @periods.map{|period| period.key }.uniq.join('|')
    end
    buf << ">"

    printer.text( buf )
  end




end   # class League

end   # module Sports
