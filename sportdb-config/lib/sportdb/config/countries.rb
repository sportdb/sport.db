# encoding: utf-8

module SportDb
  module Import

class Configuration

  ## built-in countries for (quick starter) auto-add
  COUNTRIES = {    ## rename to AUTO or BUILTIN_COUNTRIES or QUICK_COUNTRIES - why? why not?
    ## british isles
    eng: ['England',          'ENG'],     ## title/name, code
    sco: ['Scotland',         'SCO'],
    ie:  ['Ireland',          'IRL'],
    wal: ['Wales',            'WAL'],
    nir: ['Northern Ireland', 'NIR'],

    ## central europe
    at:  ['Austria',      'AUT'],
    de:  ['Germany',      'GER'],   ## use fifa code or iso? - using fifa for now
    ch:  ['Switzerland',  'SUI'],
    li:  ['Liechtenstein', 'LIE'],
    pl:  ['Poland',       'POL'],
    cz:  ['Czech Republic', 'CZE'],
    sk:  ['Slovakia', 'SVK'],
    hu:  ['Hungary',       'HUN'],
    si:  ['Slovenia', 'SVN'],

    ## western europe
    be:  ['Belgium',     'BEL'],
    nl:  ['Netherlands', 'NED'],
    lu:  ['Luxembourg',  'LUX'],
    fr:  ['France',      'FRA'],
    mc:  ['Monaco',      'MCO'],
    es:  ['Spain',       'ESP'],
    ad:  ['Andorra',     'AND'],

    ## northern europe / skandinavia
    dk:  ['Denmark',      'DEN'],
    fi:  ['Finland',      'FIN'],
    no:  ['Norway',       'NOR'],
    se:  ['Sweden',       'SWE'],

    ## eastern europe
    ro:  ['Romania',      'ROU'],
    ru:  ['Russia',       'RUS'],
    al:  ['Albania',      'ALB'],
    am:  ['Armenia',      'ARM'],
    az:  ['Azerbaijan',   'AZE'],
    ba:  ['Bosnia and Herzegovina', 'BIH'],
    bg:  ['Bulgaria', 'BUL'],
    by:  ['Belarus', 'BLR'],

    ## more european
    cy: ['Cyprus', 'CYP'],
    is: ['Iceland', 'ISL'],
    fo: ['Faroe Islands', 'FRO'],
    ge: ['Georgia', 'GEO'],
    gi: ['Gibraltar', 'GIB'],
    gr: ['Greece', 'GRE'],
    hr: ['Croatia', 'CRO'],
    it: ['Italy', 'ITA'],
    sm: ['San Marino', 'SMR'],
    ee: ['Estonia', 'EST'],
    lt: ['Lithuania', 'LTU'],
    lv: ['Latvija', 'LVA'],
    md: ['Moldova', 'MDA'],
    me: ['Montenegro', 'MNE'],
    mk: ['Macedonia', 'MKD'],
    mt: ['Malta', 'MLT'],
    pt: ['Portugal', 'POR'],
    rs: ['Serbia', 'SRB'],
    tr: ['Turkey', 'TUR'],
    ua: ['Ukraine', 'UKR'],


    ## north america
    us:  ['United States', 'USA'],
    mx:  ['Mexico',        'MEX'],
    ca:  ['Canada',        'CAN'],

    ## caribbean
    ht:  ['Haiti',               'HAI'],
    pr:  ['Puerto Rico',         'PUR'],
    tt:  ['Trinidad and Tobago', 'TRI'],

    ## central america
    cr:  ['Costa Rica',  'CRC'],
    gt:  ['Guatemala',   'GUA'],
    hn:  ['Honduras',    'HON'],
    ni:  ['Nicaragua',   'NCA'],
    pa:  ['Panama',      'PAN'],
    sv:  ['El Salvador', 'SLV'],


    ## south america
    ar:  ['Argentina',   'ARG'],
    br:  ['Brazil',      'BRA'],
    bo:  ['Bolivia',     'BOL'],
    cl:  ['Chile',       'CHI'],
    co:  ['Colombia',    'COL'],
    ec:  ['Ecuador',     'ECU'],
    gy:  ['Guyana',      'GUY'],
    pe:  ['Peru',        'PER'],
    py:  ['Paraguay',    'PAR'],
    uy:  ['Uruguay',     'URU'],
    ve:  ['Venezuela',   'VEN'],

    ## middle east
    il:  ['Israel', 'ISR'],

    ## asia
    cn:  ['China',       'CHN'],
    jp:  ['Japan',       'JPN'],
    kz:  ['Kazakhstan',  'KAZ'],
    kr:  ['South Korea', 'KOR'],

    ## africa
    eg:  ['Egypt',   'EGY'],
    ma:  ['Morocco', 'MAR'],

    ## pacific
    au:  ['Australia',   'AUS'],
    nz:  ['New Zealand', 'NZL'],
  }


  ##
  #  note: use our own (internal) country struct for now - why? why not?
  #    - check that shape/structure/fields/attributes match
  #      the Country struct in sportdb-text (in SportDb::Struct::Country)
  ##       and the ActiveRecord model !!!!
  class Country
    ## note: is read-only/immutable for now - why? why not?
    ##          add cities (array/list) - why? why not?
    attr_reader :key, :name, :code
    def initialize( key, name, code )
      @key, @name, @code = key, name, code
    end
  end  # class Country

   ## todo/check:  rename to country_mappings - why? why not?
   ##    or countries_by_code or countries_by_key
  def countries
    ## note: convertcountry data to "proper" struct
    @countries ||= COUNTRIES.each.reduce({}) do |h,(key,value)|
      ## note: convert key (e.g. :eng to string e.g. 'eng')
      h[key] = Country.new( key.to_s, value[0], value[1] )
      h
    end
    @countries
  end

end   # class Configuration
end   # module Import
end   # module SportDb

