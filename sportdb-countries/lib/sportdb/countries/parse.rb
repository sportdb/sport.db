require 'pp'

###
##   split/parse country line
##
##  split on bullet e.g.
##   split into name and code with regex - make code optional
##
##
##  Examples:
##    Österreich • Austria (at)
##    Österreich • Austria
##    Austria
##    Deutschland (de) • Germany
##
##   todo/check: support more formats - why? why not?
##       e.g.  Austria, AUT  (e.g. with comma - why? why not?)


def parse_country( line )  ## todo/fix: change to parse only
  values = line.split( '•' )   ## use/support multi-lingual separator
  country = nil
  values.each do |value|
     value = value.strip
     ## check for trailing code
     if value =~ /[ ]+\((?<code>[a-z]{1,4})\)$/  ## e.g. Austria (at)
       code =  $~[:code]
       name = value[0...(value.size-code.size-2)].strip  ## note: add -2 for brackets
       names = [name,code]
     else
       ## just assume name is value
       name = value
       names = [name]
     end
     ## check if name and code match same country
     pp names
  end
  country
end


## add split_geo helper to country_reader
def split_geo( str )
  ## assume city / geo tree
  ##  strip and squish (white)spaces
  #   e.g. León     › Guanajuato     => León › Guanajuato
  str = str.strip.gsub( /[ \t]+/, ' ' )

  ## split into geo tree
  geos = str.split( /[<>‹›]/ )   ## note: allow > < or › ‹
  geos = geos.map { |geo| geo.strip }   ## remove all whitespaces
  geos
end


pp parse_country( 'Österreich   •   Austria   (at)' )
pp parse_country( 'Austria' )
pp parse_country( 'at' )
pp parse_country( 'Deutschland  (de)  •   Germany' )
