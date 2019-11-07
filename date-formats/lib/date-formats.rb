# encoding: utf-8

require 'pp'
require 'time'
require 'date'

## 3rd party libs/gems
require 'logutils'



module DateFormats

MONTH_EN_TO_MM = {
      'Jan' => '1', 'January' => '1',
      'Feb' => '2', 'February' => '2',
      'Mar' => '3', 'March' => '3',
      'Apr' => '4', 'April' => '4',
      'May' => '5',
      'Jun' => '6', 'June' => '6',
      'Jul' => '7', 'July' => '7',
      'Aug' => '8', 'August' => '8',
      'Sep' => '9', 'Sept' => '9', 'September' => '9',
      'Oct' => '10', 'October' => '10',
      'Nov' => '11', 'November' => '11',
      'Dec' => '12', 'December' =>'12' }

MONTH_EN = 'January|Jan|'+
           'February|Feb|'+
           'March|Mar|'+
           'April|Apr|'+
           'May|'+
           'June|Jun|'+
           'July|Jul|'+
           'August|Aug|'+
           'September|Sept|Sep|'+
           'October|Oct|'+
           'November|Nov|'+
           'December|Dec'

###
## todo: add days
## 1. Sunday - Sun.	2. Monday - Mon.
## 3. Tuesday - Tu., Tue., or Tues.	4. Wednesday - Wed.
## 5. Thursday - Th., Thu., Thur., or Thurs.	6. Friday - Fri.
## 7. Saturday - Sat.



MONTH_FR_TO_MM = {
      'Janvier' => '1', 'Janv' => '1', 'Jan' => '1',   ## check janv in use??
      'Février' => '2', 'Févr' => '2', 'Fév' => '2',   ## check fevr in use???
      'Mars'    => '3', 'Mar' => '3',
      'Avril'   => '4', 'Avri' => '4', 'Avr' => '4',   ## check avri in use??? if not remove
      'Mai'     => '5',
      'Juin'    => '6',
      'Juillet' => '7', 'Juil' => '7',
      'Août'    => '8',
      'Septembre' => '9', 'Sept' => '9',
      'Octobre' => '10',  'Octo' => '10', 'Oct' => '10',  ### check octo in use??
      'Novembre' => '11', 'Nove' => '11', 'Nov' => '11',  ##  check nove in use??
      'Décembre' => '12', 'Déce' => '12', 'Déc' => '12' } ## check dece in use??

MONTH_FR = 'Janvier|Janv|Jan|' +
           'Février|Févr|Fév|' +
           'Mars|Mar|' +
           'Avril|Avri|Avr|' +
           'Mai|'  +
           'Juin|' +
           'Juillet|Juil|' +
           'Août|' +
           'Septembre|Sept|' +
           'Octobre|Octo|Oct|' +
           'Novembre|Nove|Nov|' +
           'Décembre|Déce|Déc'

WEEKDAY_FR = 'Lundi|Lun|L|' +
         'Mardi|Mar|Ma|' +
         'Mercredi|Mer|Me|' +
         'Jeudi|Jeu|J|' +
         'Vendredi|Ven|V|' +
         'Samedi|Sam|S|' +
         'Dimanche|Dim|D|'


MONTH_ES_TO_MM  = {
      'Ene' => '1', 'Enero' => '1',
      'Feb' => '2',
      'Mar' => '3', 'Marzo' => '3',
      'Abr' => '4', 'Abril' => '4',
      'May' => '5', 'Mayo' => '5',
      'Jun' => '6', 'Junio' => '6',
      'Jul' => '7', 'Julio' => '7',
      'Ago' => '8', 'Agosto' => '8',
      'Sep' => '9', 'Set' => '9', 'Sept' => '9',
      'Oct' => '10',
      'Nov' => '11',
      'Dic' => '12' }

MONTH_ES = 'Enero|Ene|'+
           'Feb|'+
           'Marzo|Mar|'+
           'Abril|Abr|'+
           'Mayo|May|'+
           'Junio|Jun|'+
           'Julio|Jul|'+
           'Agosto|Ago|'+
           'Sept|Set|Sep|'+
           'Oct|'+
           'Nov|'+
           'Dic'


# todo: make more generic for reuse
### fix:
##    use  date/fr.yml  en.yml etc. --  why? why not?

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
