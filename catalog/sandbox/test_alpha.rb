##############################
# for lookup and key gen try/test unaccent function (from alphabets)

require 'alphabets'
require 'cocos'



names = %w[
    FC_Petrolul_Ploiești
    Ploiești
    Petrolul_Ploiesti
    Petrolul_Ploiești

    Steaua_București
    Steaua_Bucuresti
    București
    FC_Steaua_Bucuresti
    FC_Steaua_București

    Ceahlăul_Piatra_Neamț
    Ceahlaul_Piatra_Neamt
    Piatra_Neamț

    FC_Botoșani
    FC_Botoşani
    Botoşani

    Oţelul
    Oțelul
]

pp names

names.each do |name|
    ascii = unaccent(name)
    puts "%-20s  =>  %-20s  /  %-20s" % [name, ascii, ascii.downcase]
end


puts "bye"

