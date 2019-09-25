# encoding: utf-8

module SportDb
module Import


class CountryReader


def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
  txt = File.open( path, 'r:utf-8' ).read
  parse( txt )
end


def self.parse( txt )
  countries = []

  recs = parse_csv( txt )

  ###########################################
  ## auto-fill countries
  ## pp recs
  recs.each do |rec|
    ## rec e.g. { key:'af', fifa:'AFG', name:'Afghanistan'}

    key  = rec[:key]
    ## note: remove territory of marker e.g. (UK), (US), etc. from name
    ##    e.g. England (UK)     => England
    ##         Puerto Rico (US) => Puerto Rico
    name = rec[:name].sub( /\([A-Z]{2}\)/, '' ).strip
    fifa = rec[:fifa]

    country = Country.new( key, name, fifa )
    countries << country
  end

  countries
end  # method parse

end  # class CountryReader

end   # module Import
end   # module SportDb
