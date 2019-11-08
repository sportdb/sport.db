module DateFormats
module Source

# todo: make more generic for reuse
### fix:
##    use  date/en.txt or en.txt etc. --  why? why not?

##  note: always sort lines with longest words, abbrevations first!!!!

  MONTH_EN = <<TXT
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

  DAY_EN = <<TXT
Monday      Mon
Tuesday     Tues  Tue  Tu
Wednesday   Wed
Thursday    Thurs  Thur  Thu  Th
Friday      Fri
Saturday    Sat
Sunday      Sun
TXT



  MONTH_FR = <<TXT
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

  DAY_FR = <<TXT
Lundi     Lun  L
Mardi     Mar  Ma
Mercredi  Mer  Me
Jeudi     Jeu  J
Vendredi  Ven  V
Samedi    Sam  S
Dimanche  Dim  D
TXT



  MONTH_ES = <<TXT
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

  MONTH_DE = <<TXT
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

  MONTH_IT = <<TXT
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

  MONTH_PT = <<TXT
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

  MONTH_RO = <<TXT
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

end # module Source
end # module DateFormats
