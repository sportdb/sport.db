module DateFormats

# todo: make more generic for reuse
### fix:
##    use  date/en.txt or en.txt etc. --  why? why not?

##  note: always sort lines with longest words, abbrevations first!!!!
##  todo/fix: add/split into MONTH_NAMES and MONTH_ABBREVS (and DAY_NAMES and DAY_ABBREVS) - why? why not?
  MONTH_NAMES = {}
  DAY_NAMES   = {}


  MONTH_NAMES[:en] = <<TXT
January    Jan
February   Feb
March      Mar
April      Apr
May
June       Jun
July       Jul
August     Aug
September  Sept  Sep
October    Oct
November   Nov
December   Dec
TXT


  DAY_NAMES[:en] = <<TXT
Monday      Mon
Tuesday     Tues  Tue  Tu
Wednesday   Wed
Thursday    Thurs  Thur  Thu  Th
Friday      Fri
Saturday    Sat
Sunday      Sun
TXT



  MONTH_NAMES[:fr] = <<TXT
Janvier    Janv   Jan     ## check janv in use??
Février    Févr   Fév     ## check fevr in use???
Mars              Mar
Avril      Avri   Avr     ## check avri in use??? if not remove
Mai
Juin
Juillet    Juil
Août
Septembre  Sept
Octobre    Octo   Oct     ## check octo in use??
Novembre   Nove   Nov     ##  check nove in use??
Décembre   Déce   Déc     ## check dece in use??
TXT

  DAY_NAMES[:fr] = <<TXT
Lundi     Lun  L
Mardi     Mar  Ma
Mercredi  Mer  Me
Jeudi     Jeu  J
Vendredi  Ven  V
Samedi    Sam  S
Dimanche  Dim  D
TXT



  MONTH_NAMES[:es] = <<TXT
Enero      Ene
Febrero    Feb
Marzo      Mar
Abril      Abr
Mayo       May
Junio      Jun
Julio      Jul
Agosto     Ago
Septiembre  Sept  Sep  Set    ## check set in use??
Octubre    Oct
Noviembre  Nov
Diciembre  Dic
TXT

  MONTH_NAMES[:de] = <<TXT
Jänner  Januar    Jan  Jän    # note: in Austria - Jänner; in Deutschland Januar allow both ??
Feber   Februar   Feb
März              Mär
April             Apr
Mai               Mai
Juni              Jun
Juli              Jul
August            Aug
September         Sep
Oktober           Okt
November          Nov
Dezember          Dez
TXT

  MONTH_NAMES[:it] = <<TXT
Gennaio
Febbraio
Marzo
Aprile
Maggio
Giugno
Luglio
Agosto
Settembre
Ottobre
Novembre
Dicembre
TXT

  MONTH_NAMES[:pt] = <<TXT
Janeiro
Fevereiro
Março
Abril
Maio
Junho
Julho
Agosto
Setembro
Outubro
Novembro
Dezembro
TXT

  MONTH_NAMES[:ro] = <<TXT
Ianuarie
Februarie
Martie
Aprilie
Mai
Iunie
Iulie
August
Septembrie
Octombrie
Noiembrie
Decembrie
TXT

############################################
## convert (unparsed) text to (parsed) lines with words
MONTH_NAMES.each {|k,v| MONTH_NAMES[k] = parse_month(v) }
DAY_NAMES.each   {|k,v| DAY_NAMES[k]   = parse_day(v) }

end # module DateFormats
