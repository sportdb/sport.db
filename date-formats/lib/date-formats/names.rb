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
Monday                   Mon
Tuesday            Tues  Tue  Tu
Wednesday                Wed
Thursday    Thurs  Thur  Thu  Th
Friday                   Fri
Saturday                 Sat
Sunday                   Sun
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
Lundi     Lun  Lu  L
Mardi     Mar  Ma
Mercredi  Mer  Me
Jeudi     Jeu  Je  J
Vendredi  Ven  Ve  V
Samedi    Sam  Sa  S
Dimanche  Dim  Di  D
TXT


  MONTH_NAMES[:es] = <<TXT
Enero             Ene
Febrero           Feb
Marzo             Mar
Abril             Abr
Mayo              May
Junio             Jun
Julio             Jul
Agosto            Ago
Septiembre  Sept  Sep Set    ## check Set in use??
Octubre           Oct
Noviembre         Nov
Diciembre         Dic
TXT

  DAY_NAMES[:es] = <<TXT
Lunes       Lun      Lu
Martes      Mar      Ma
Miércoles   Mié Mie  Mi      # note: add unaccented variant (for abbreviation) - why? why not?
Jueves      Jue      Ju
Viernes     Vie      Vi
Sábado      Sáb Sab  Sá Sa   # note: add unaccented variants (for abbreviations) - why? why not?
Domingo     Dom      Do
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

  DAY_NAMES[:de] = <<TXT
Montag      Mo
Dienstag    Di
Mittwoch    Mi
Donnerstag  Do
Freitag     Fr
Samstag     Sa
Sonntag     So
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

  DAY_NAMES[:it] = <<TXT
Lunedì    Lun
Martedì   Mar
Mercoledì Mer
Giovedì   Gio
Venerdì   Ven
Sabato    Sab
Domenica  Dom   Do
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

  DAY_NAMES[:pt] = <<TXT
Segunda-feira  Seg
Terça-feira    Ter
Quarta-feira   Qua
Quinta-feira   Qui
Sexta-feira    Sex
Sábado         Sab
Domingo        Dom
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

   DAY_NAMES[:ro] = <<TXT
Luni      Lu
Marți     Ma
Miercuri  Mi
Joi       Jo
Vineri    Vi
Sâmbătă   Sb
Duminică  Du
TXT



  DAY_NAMES[:nl] = <<TXT
Maandag          Ma
Dinsdag          Di
Woensdag   Woe   Wo
Donderdag  Don   Do
Vrijdag    Vrij  Vr
Zaterdag   Zat   Za
Zondag     Zon   Zo
TXT

  DAY_NAMES[:cz] = <<TXT
Pondělí  Po
Úterý    Út
Středa   St
Čtvrtek  Čt
Pátek    Pá
Sobota   So
Neděle   Ne
TXT

  DAY_NAMES[:hu] = <<TXT
Hétfő      H
Kedd       K
Szerda     Sze
Csütörtök  Csüt
Péntek     P
Szombat    Szo
Vasárnap   Vas
TXT




############################################
## convert (unparsed) text to (parsed) lines with words
MONTH_NAMES.each {|k,v| MONTH_NAMES[k] = parse_month(v) }
DAY_NAMES.each   {|k,v| DAY_NAMES[k]   = parse_day(v) }

end # module DateFormats
