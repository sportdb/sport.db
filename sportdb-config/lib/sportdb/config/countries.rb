# encoding: utf-8

module SportDb
  module Import

class Configuration

  ## built-in countries for (quick starter) auto-add
  COUNTRIES = {    ## rename to AUTO or BUILTIN_COUNTRIES or QUICK_COUNTRIES - why? why not?
    ## british isles
    eng: ['England',     'ENG'],     ## title/name, code
    sco: ['Scotland',    'SCO'],
    ie:  ['Ireland',     'IRL'],

    ## central europe
    at:  ['Austria',      'AUT'],
    de:  ['Germany',      'GER'],   ## use fifa code or iso? - using fifa for now
    ch:  ['Switzerland',  'SWZ'],
    pl:  ['Poland',       'POL'],

    ## western europe
    fr:  ['France',      'FRA'],
    es:  ['Spain',       'ESP'],
    be:  ['Belgium',     '' ],
    nl:  ['Netherlands', '' ],

    ## northern europe / skandinavia
    dk:  ['Denmark',      'DNK'],
    fi:  ['Finland',      'FIN'],
    no:  ['Norway',       'NOR'],
    se:  ['Sweden',       'SWE'],

    ## eastern europe
    ro:  ['Romania',      'ROU'],
    ru:  ['Russia',       'RUS'],

    ## north america
    us:  ['United States', 'USA'],
    mx:  ['Mexico',        'MEX'],

    ## caribbean
    ht:  ['Haiti',               ''],
    pr:  ['Puerto Rico',         ''],
    tt:  ['Trinidad and Tobago', ''],

    ## central america
    cr:  ['Costa Rica',  ''],
    gt:  ['Guatemala',   ''],
    hn:  ['Honduras',    ''],
    ni:  ['Nicaragua',   ''],
    pa:  ['Panama',      ''],
    sv:  ['El Salvador', ''],

    ## south america
    ar:  ['Argentina',   'ARG'],
    br:  ['Brazil',      'BRA'],
    bo:  ['Bolivia',     ''],
    cl:  ['Chile',       ''],
    co:  ['Colombia',    ''],
    ec:  ['Ecuador',     ''],
    gy:  ['Guyana',      ''],
    pe:  ['Peru',        ''],
    py:  ['Paraguay',    ''],
    uy:  ['Uruguay',     ''],
    ve:  ['Venezuela',   ''],

    ## asia
    cn:  ['China',       'CHN'],
    jp:  ['Japan',       'JPN'],
    kz:  ['Kazakhstan',  '' ],
    kr:  ['South Korea', '' ],

    ## africa
    eg:  ['Egypt',   ''],
    ma:  ['Morocco', ''],
  }

## add more countries - see/check datasets !!
=begin
[["eg", "../../../openfootball/clubs/africa/egypt/eg.clubs.txt"],
 ["ma", "../../../openfootball/clubs/africa/morocco/ma.clubs.txt"],
 ["cn", "../../../openfootball/clubs/asia/china/cn.clubs.txt"],
 ["jp", "../../../openfootball/clubs/asia/japan/jp.clubs.txt"],
 ["kz", "../../../openfootball/clubs/asia/kazakhstan/kz.clubs.txt"],
 ["kr", "../../../openfootball/clubs/asia/south-korea/kr.clubs.txt"],
 ["ht", "../../../openfootball/clubs/caribbean/haiti/ht.clubs.txt"],
 ["pr", "../../../openfootball/clubs/caribbean/puerto-rico/pr.clubs.txt"],
 ["tt",
  "../../../openfootball/clubs/caribbean/trinidad-n-tobago/tt.clubs.txt"],
 ["cr", "../../../openfootball/clubs/central-america/costa-rica/cr.clubs.txt"],
 ["gt", "../../../openfootball/clubs/central-america/guatemala/gt.clubs.txt"],
 ["hn", "../../../openfootball/clubs/central-america/hn-honduras/clubs.txt"],
 ["ni", "../../../openfootball/clubs/central-america/ni-nicaragua/clubs.txt"],
 ["pa", "../../../openfootball/clubs/central-america/pa-panama/clubs.txt"],
 ["sv",
  "../../../openfootball/clubs/central-america/sv-el-salvador/clubs.txt"],
 ["ad", "../../../openfootball/clubs/europe/ad-andorra/clubs.txt"],
 ["al", "../../../openfootball/clubs/europe/al-albania/clubs.txt"],
 ["am", "../../../openfootball/clubs/europe/am-armenia/clubs.txt"],
 ["at", "../../../openfootball/clubs/europe/at-austria/clubs.txt"],
 ["az", "../../../openfootball/clubs/europe/az-azerbaijan/clubs.txt"],
 ["ba",
  "../../../openfootball/clubs/europe/ba-bosnia-n-herzegovina/clubs.txt"],
 ["be", "../../../openfootball/clubs/europe/be-belgium/clubs.txt"],
 ["bg", "../../../openfootball/clubs/europe/bg-bulgaria/clubs.txt"],
 ["by", "../../../openfootball/clubs/europe/by-belarus/clubs.txt"],
 ["ch",
  "../../../openfootball/clubs/europe/ch-confoederatio-helvetica/clubs.txt"],
 ["cy", "../../../openfootball/clubs/europe/cy-cyprus/clubs.txt"],
 ["cz", "../../../openfootball/clubs/europe/cz-czech-republic/clubs.txt"],
 ["de", "../../../openfootball/clubs/europe/de-deutschland/clubs.txt"],
 ["dk", "../../../openfootball/clubs/europe/dk-denmark/clubs.txt"],
 ["ee", "../../../openfootball/clubs/europe/ee-estonia/clubs.txt"],
 ["eng", "../../../openfootball/clubs/europe/eng-england/clubs.txt"],
 ["es", "../../../openfootball/clubs/europe/es-espana/clubs.txt"],
 ["fi", "../../../openfootball/clubs/europe/fi-finland/clubs.txt"],
 ["fo", "../../../openfootball/clubs/europe/fo-faroe-islands/clubs.txt"],
 ["fr", "../../../openfootball/clubs/europe/fr-france/clubs.txt"],
 ["ge", "../../../openfootball/clubs/europe/ge-georgia/clubs.txt"],
 ["gi", "../../../openfootball/clubs/europe/gi-gibraltar/clubs.txt"],
 ["gr", "../../../openfootball/clubs/europe/gr-greece/clubs.txt"],
 ["hr", "../../../openfootball/clubs/europe/hr-croatia/clubs.txt"],
 ["hu", "../../../openfootball/clubs/europe/hu-hungary/clubs.txt"],
 ["ie", "../../../openfootball/clubs/europe/ie-ireland/clubs.txt"],
 ["is", "../../../openfootball/clubs/europe/is-iceland/clubs.txt"],
 ["it", "../../../openfootball/clubs/europe/it-italy/clubs.txt"],
 ["li", "../../../openfootball/clubs/europe/li-liechtenstein/clubs.txt"],
 ["lt", "../../../openfootball/clubs/europe/lt-lithuania/clubs.txt"],
 ["lu", "../../../openfootball/clubs/europe/lu-luxembourg/clubs.txt"],
 ["lv", "../../../openfootball/clubs/europe/lv-latvija/clubs.txt"],
 ["mc", "../../../openfootball/clubs/europe/mc-monaco/clubs.txt"],
 ["md", "../../../openfootball/clubs/europe/md-moldova/clubs.txt"],
 ["me", "../../../openfootball/clubs/europe/me-montenegro/clubs.txt"],
 ["mk", "../../../openfootball/clubs/europe/mk-macedonia/clubs.txt"],
 ["mt", "../../../openfootball/clubs/europe/mt-malta/clubs.txt"],
 ["nir", "../../../openfootball/clubs/europe/nir-northern-ireland/clubs.txt"],
 ["nl", "../../../openfootball/clubs/europe/nl-netherlands/clubs.txt"],
 ["no", "../../../openfootball/clubs/europe/no-norway/clubs.txt"],
 ["pl", "../../../openfootball/clubs/europe/pl-poland/clubs.txt"],
 ["pt", "../../../openfootball/clubs/europe/pt-portugal/clubs.txt"],
 ["ro", "../../../openfootball/clubs/europe/ro-romania/clubs.txt"],
 ["rs", "../../../openfootball/clubs/europe/rs-serbia/clubs.txt"],
 ["ru", "../../../openfootball/clubs/europe/ru-russia/clubs.txt"],
 ["sco", "../../../openfootball/clubs/europe/sco-scotland/clubs.txt"],
 ["se", "../../../openfootball/clubs/europe/se-sweden/clubs.txt"],
 ["si", "../../../openfootball/clubs/europe/si-slovenia/clubs.txt"],
 ["sk", "../../../openfootball/clubs/europe/sk-slovakia/clubs.txt"],
 ["sm", "../../../openfootball/clubs/europe/sm-san-marino/clubs.txt"],
 ["tr", "../../../openfootball/clubs/europe/tr-turkey/clubs.txt"],
 ["ua", "../../../openfootball/clubs/europe/ua-ukraine/clubs.txt"],
 ["wal", "../../../openfootball/clubs/europe/wal-wales/clubs.txt"],
 ["il", "../../../openfootball/clubs/middle-east/il-israel/clubs.txt"],
 ["ca", "../../../openfootball/clubs/north-america/ca-canada/clubs.txt"],
 ["mx", "../../../openfootball/clubs/north-america/mx-mexico/clubs.txt"],
 ["us",
  "../../../openfootball/clubs/north-america/us-united-states/clubs.txt"],
 ["au", "../../../openfootball/clubs/pacific/australia/au.clubs.txt"],
 ["nz", "../../../openfootball/clubs/pacific/new-zealand/nz.clubs.txt"],
 ["ar", "../../../openfootball/clubs/south-america/argentina/ar.clubs.txt"],
 ["bo", "../../../openfootball/clubs/south-america/bolivia/bo.clubs.txt"],
 ["br", "../../../openfootball/clubs/south-america/brazil/br.clubs.txt"],
 ["cl", "../../../openfootball/clubs/south-america/chile/cl.clubs.txt"],
 ["co", "../../../openfootball/clubs/south-america/co-colombia/clubs.txt"],
 ["ec", "../../../openfootball/clubs/south-america/ec-ecuador/clubs.txt"],
 ["gy", "../../../openfootball/clubs/south-america/gy-guyana/clubs.txt"],
 ["pe", "../../../openfootball/clubs/south-america/pe-peru/clubs.txt"],
 ["py", "../../../openfootball/clubs/south-america/py-paraguay/clubs.txt"],
 ["uy", "../../../openfootball/clubs/south-america/uy-uruguay/clubs.txt"],
 ["ve", "../../../openfootball/clubs/south-america/ve-venezuela/clubs.txt"]]
=end

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
