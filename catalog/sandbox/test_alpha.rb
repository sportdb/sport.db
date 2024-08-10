##############################
# for lookup and key gen try/test unaccent function (from alphabets)

require 'alphabets'
require 'cocos'



names = parse_data( <<TXT)
    FC Petrolul Ploiești
    Ploiești
    Petrolul Ploiesti
    Petrolul Ploiești

    Steaua București
    Steaua Bucuresti
    București
    FC Steaua Bucuresti
    FC Steaua București

    Ceahlăul PiatraNeamț
    Ceahlaul Piatra Neamt
    Piatra Neamț

    FC Botoșani
    FC Botoşani
    Botoşani

    Oţelul
    Oțelul

    Constel·lació
    Constellació
TXT

## note about -  Constel·lació
## in catalan
##
## The punt volat ("flying point") is used in Catalan between two Ls
## in cases where each belongs to a separate syllable,
## for example cel·la, "cell".
## This distinguishes such "geminate Ls" (ela geminada),
## which are pronounced [ɫː], from "double L" (doble ela),
## which are written without the flying point and are pronounced [ʎ].
## In situations where the flying point is unavailable,
## periods (as in col.lecció) or hyphens (as in col-lecció)
## are frequently used as substitutes,
## but this is tolerated rather than encouraged.
##
##  in normalize (or in unaccent)
##  keep interpunct? or translate to ascii? or remove?? why? why not?


pp names

names.each do |name,_|
    ascii = unaccent(name)
    puts "%-20s  =>  %-20s  /  %-20s" % [name, ascii, ascii.downcase]
end



## todo:
## check for unicode chars (interpunct et.c)
## pp "Constel·lació"
##   FC Botoșani
## FC Botoşani
## Oţelul
## Oțelul


puts "bye"

