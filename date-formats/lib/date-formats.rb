# encoding: utf-8

require 'pp'
require 'time'
require 'date'

## 3rd party libs/gems
require 'logutils'


###
# our own code
require 'date-formats/version' # let version always go first
require 'date-formats/source'
require 'date-formats/reader'


module DateFormats
  
MONTH_NAMES = {
  en: Reader.parse_month( Source::MONTH_EN ),
  fr: Reader.parse_month( Source::MONTH_FR ),
  es: Reader.parse_month( Source::MONTH_ES ),
}

DAY_NAMES = {
  en: Reader.parse_day( Source::DAY_EN ),
  fr: Reader.parse_day( Source::DAY_FR ),
}

  
MONTH_EN       = build_re( MONTH_NAMES[:en] )
DAY_EN         = build_re( DAY_NAMES[:en] )

MONTH_FR       = build_re( MONTH_NAMES[:fr] )
DAY_FR         = build_re( DAY_NAMES[:fr] )

MONTH_ES       = build_re( MONTH_NAMES[:es] )



MONTH_DE_LINES = Reader.parse_month( Source::MONTH_DE )
MONTH_DE_TO_MM = build_map( MONTH_DE_LINES )
MONTH_DE       = build_re( MONTH_DE_LINES )

  
## MONTH_EN_TO_MM = build_map( MONTH_EN_LINES )   ### fix: move inside date parser  and ALWAYS downcase (fix: add downcase)
## MONTH_FR_TO_MM = build_map( MONTH_FR_LINES )     ### fix: move inside date parser
## MONTH_ES_TO_MM = build_map( MONTH_ES_LINES )
    
end  # module DateFormats



require 'date-formats/formats'
require 'date-formats/date'




puts DateFormats.banner   # say hello
