# encoding: utf-8

require 'pp'
require 'time'
require 'date'

## 3rd party libs/gems
require 'logutils'



module DateFormats

      
MONTH_EN_LINES = Reader.parse_month( Source::MONTH_EN )
MONTH_EN_TO_MM = build_map( MONTH_EN_LINES )
MONTH_EN       = build_re( MONTH_EN_LINES )
            
###
## todo: add days
## 1. Sunday - Sun.	2. Monday - Mon.
## 3. Tuesday - Tu., Tue., or Tues.	4. Wednesday - Wed.
## 5. Thursday - Th., Thu., Thur., or Thurs.	6. Friday - Fri.
## 7. Saturday - Sat.

      
MONTH_FR_LINES = Reader.parse_month( Source::MONTH_FR )
MONTH_FR_TO_MM = build_map( MONTH_FR_LINES )
MONTH_FR       = build_re( MONTH_FR_LINES )


WEEKDAY_FR = 'Lundi|Lun|L|' +
         'Mardi|Mar|Ma|' +
         'Mercredi|Mer|Me|' +
         'Jeudi|Jeu|J|' +
         'Vendredi|Ven|V|' +
         'Samedi|Sam|S|' +
         'Dimanche|Dim|D|'


MONTH_ES_LINES = Reader.parse_month( Source::MONTH_ES )
MONTH_ES_TO_MM = build_map( MONTH_ES_LINES )
MONTH_ES       = build_re( MONTH_ES_LINES )

      
# todo/fix - add de and es too!!
# note: in Austria - Jänner - in Deutschland Januar allow both ??
# MONTH_DE = 'J[aä]n|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sep|Okt|Nov|Dez'

end  # module DateFormats



###
# our own code
require 'date-formats/version' # let version always go first
require 'date-formats/formats'
require 'date-formats/date'




puts DateFormats.banner   # say hello
