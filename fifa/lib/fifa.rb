# encoding: utf-8


## 3rd party gems
require 'sportdb/countries'


###
# our own code
require 'fifa/version' # let version always go first
require 'fifa/countries'


class Fifa
  def self.countries() country_index.countries; end   ## return all country (struct-like) records
  def self.[]( key )   country_index[ key ]; end


  ALT_ORG_NAMES = {
    'world'  => 'fifa',
    'europe' => 'uefa',    #=> Union of European Football Associations
    'northamericacentralamericacaribbean' => 'concacaf',  #=> Confederation of North, Central American and Caribbean Association Football
    'northcentralamericacaribbean'        => 'concacaf',  ## e.g. North & Central America and the Caribbean
    'northamerica' => 'nafu',  # => North American Football Union
    'centralamerica' => 'uncaf',  #=> Unión Centroamericana de Fútbol
    'caribbean' => 'cfu',  #=> Caribbean Football Union
    'africa' => 'caf',      # => Confédération Africaine de Football
    'eastcentralafrica' => 'cecafa',  # => Council for East and Central Africa Football Associations
    'southernafrica' => 'cosafa',   # => Council of Southern Africa Football Associations
    'westafrica' => 'wafu',         # => West African Football Union/Union du Football de l'Ouest Afrique
    'northafrica' => 'unaf',        # => Union of North African Federations
    'centralafrica' => 'uniffac',  # => Union des Fédérations du Football de l'Afrique Centrale
    'asia'   => 'afc',      # => Asian Football Confederation
    'middleeast' => 'waff', # => West Asian Football Federation  -- note: excludes Iran and Israel
    'eastasia'   => 'eaff',
    'centralasia' => 'cafa',
    'southasia' => 'saff',
    'southeastasia' => 'aff',
    'oceania'    => 'ofc',  # =>  Oceania Football Confederation
    'pacific'    => 'ofc',
    'southamerica' => 'conmebol',  #=>  Confederación Sudamericana de Fútbol
  }

  def self.members( key=:fifa )   ## default to fifa members
    key       = key.to_s.downcase
    countries = org_index[ key ]

    if countries.nil?    ## (re)try / check with alternative (convenience) org name
      alt_key = ALT_ORG_NAMES[ normalize_org( key ) ]
      countries = org_index[ alt_key ]   if alt_key
    end
    countries
  end

  def self.normalize_org( name )
    ## remove space, comma, ampersand (&) and words: and, the
    name.gsub( /[ ,&]|\band\b|\bthe\b/, '' )
  end


  def self.orgs()  org_index.keys; end   ## return list of known org (keys) e.g. fifa, uefa, etc.

private
  def self.country_index
    @country_index ||= build_country_index
    @country_index
  end

  def self.build_country_index
    recs = SportDb::Import::CountryReader.read( "#{Fifa.data_dir}/countries.txt" )
    CountryIndex.new( recs )
  end


  def self.org_index
    @org_index ||= build_org_index   ## fifa,uefa,etc.
    @org_index
  end

  def self.build_org_index
    orgs = {}
    countries.each do |country|
      ## note: assumes all tags are sport / fifa tags for now
       country.tags.each do |tag|
         orgs[ tag ] ||= []
         orgs[ tag ] << country
       end
    end
    orgs
  end
end # class Fifa


## add a convenience upcase alias
FIFA = Fifa



puts Fifa.banner   # say hello
