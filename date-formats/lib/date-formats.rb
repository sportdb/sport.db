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


MONTH_EN_LINES    = Reader.parse_month( Source::MONTH_EN )
MONTH_EN_TO_MM    = build_map( MONTH_EN_LINES )
MONTH_EN          = build_re( MONTH_EN_LINES )

WEEKDAY_EN_LINES  = Reader.parse_weekday( Source::WEEKDAY_EN )
WEEKDAY_EN        = build_re( WEEKDAY_EN_LINES )



MONTH_FR_LINES    = Reader.parse_month( Source::MONTH_FR )
MONTH_FR_TO_MM    = build_map( MONTH_FR_LINES )
MONTH_FR          = build_re( MONTH_FR_LINES )

WEEKDAY_FR_LINES  = Reader.parse_weekday( Source::WEEKDAY_FR )
WEEKDAY_FR        = build_re( WEEKDAY_FR_LINES )



MONTH_ES_LINES    = Reader.parse_month( Source::MONTH_ES )
MONTH_ES_TO_MM    = build_map( MONTH_ES_LINES )
MONTH_ES          = build_re( MONTH_ES_LINES )



MONTH_DE_LINES    = Reader.parse_month( Source::MONTH_DE )
MONTH_DE_TO_MM    = build_map( MONTH_DE_LINES )
MONTH_DE          = build_re( MONTH_DE_LINES )

end  # module DateFormats



require 'date-formats/formats'
require 'date-formats/date'




puts DateFormats.banner   # say hello
