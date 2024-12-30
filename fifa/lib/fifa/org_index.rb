
module Fifa

class CountryIndex   ## note - OrdIndex (helper) nested inside CountryIndex - why? why not?
class OrgIndex      ## change to MemberIndex or AssocIndex or such - why? why not?

    ALT_KEYS = {
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


    def initialize( countries=nil )
        @orgs = {}   ## countries by org (key)

        add( countries )  if countries
    end

    def add( countries )
        countries.each do |country|
            ## note: assumes all tags are sport / fifa tags for now
            country.tags.each do |tag|
              @orgs[ tag ] ||= []
              @orgs[ tag ] << country
            end
         end
    end


    def keys() @orgs.keys; end

    def members( key=:fifa )   ## default to fifa members
      key       = key.to_s.downcase
      countries = @orgs[ key ]

      if countries.nil?    ## (re)try / check with alternative (convenience) org name
        alt_key = ALT_KEYS[ _norm_org( key ) ]
        countries = @orgs[ alt_key ]   if alt_key
      end
      countries
    end


    def _norm_org( name )
      ## remove space, comma, ampersand (&) and words: and, the
      name.gsub( /  [ ,&] |
                   \band\b |
                   \bthe\b
                 /x, '' )
    end

end  # class OrgIndex
end  # class CountryIndex
end # module Fifa


