##############################
# for lookup and key gen try/test unaccent function (from alphabets)

require 'alphabets'
require 'cocos'


## minitest setup
require 'minitest/autorun'


##
# notes:
#   ß    to ss - yes 
#   ö    to o  - yes, (NOT to oe) 
#
#
#  todo/check: use our own downcase method - why? why not?
#     if unaccent before downcase (downcase ascii should always work!!)


#
DATA = parse_data( <<TXT )
  B93 København,        b93 kobenhavn
  Preußen Münster,      preussen munster
  Rot-Weiß Oberhausen,  rot-weiss oberhausen
  Rot-Weiss Essen,      rot-weiss essen
  St. Pölten,           st. polten
  USC Grafenwörth,      usc grafenworth
  USC Kirchberg/W.,     usc kirchberg/w.

  FK Viktoria Žižkov,   fk viktoria zizkov
  Viktoria Plzeň,       viktoria plzen 

  LB Châteauroux,       lb chateauroux
  Nîmes Olympique,      nimes olympique
  AS Saint-Étienne,     as saint-etienne
  Racing Besançon,      racing besancon

  Atlético Madrid,      atletico madrid
  Málaga CF,            malaga cf
  Córdoba CF,           cordoba cf
  RCD La Coruña,        rcd la coruna

  Djurgårdens IF,       djurgardens if
  Örgryte Göteborg,     orgryte goteborg
  Åtvidabergs FF,       atvidabergs ff

  Fenerbahçe İstanbul,   fenerbahce istanbul
  Beşiktaş İstanbul,     besiktas istanbul
  Kasımpaşa İstanbul,    kasimpasa istanbul
  İstanbul Başakşehir,   istanbul basaksehir
  Çaykur Rizespor,       caykur rizespor

  São Paulo FC,        sao paulo fc
  União São João,      uniao sao joao
  América MG,          america mg
  Grêmio RS,           gremio rs
  Avaí FC,             avai fc
  Brasília FC,         brasilia fc

  Grobiņas SC,         grobinas sc
  Grobiņa,             grobina
TXT

pp DATA
puts "  #{DATA.size} names(s)"



class TestNames < Minitest::Test


def test_names
  DATA.each do |name, exp|
    ascii = unaccent(name)
    puts "%-20s  =>  %-20s  /  %-20s" % [name, ascii, ascii.downcase]

    # pp exp.encoding      #=> <Encoding:UTF-8>
    # pp ascii.encoding    #=> <Encoding:ASCII-8BIT>
    assert_equal exp.encode( 'ascii-8bit'), ascii.downcase

    assert ascii.chars.size          >= name.chars.size, "less chars than original ------^^"
    assert ascii.downcase.chars.size >= name.chars.size, "less chars in downcase than original ------^^"
  end
end # method test_names
end # class TestNames
