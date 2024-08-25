###
#  to run use
#     ruby test/test_ground_reader.rb


require_relative 'helper'

class TestGroundReader < Minitest::Test

  def test_parse_de
    recs = SportDb::Import::GroundReader.parse( <<TXT )

============================================
= Germany

== Berlin ==

Olympiastadion,   74_176, 1936, Berlin            # Hertha BSC
   | Olympiastadion Berlin     ## (always) auto-add city to canonical name - why? why not?
   Olympischer Platz 3 // 14053 Berlin

Alte Försterei, 21_738, 1920, Berlin              # 1. FC Union Berlin
  | Stadion An der Alten Försterei
  An der Wuhlheide 263 // 12555 Berlin


== Nordrhein-Westfalen ==

Westfalenstadion,   67_000,   Dortmund    #  Borussia Dortmund
  | $Signal Iduna$ Park
  | BVB Stadion Dortmund   # euro 2024 name
  Strobelallee 50 // 44139 Dortmund

Arena Auf Schalke,  53_804,  Gelsenkirchen    # FC Schalke 04
  | $Veltins$-Arena
  Rudi-Assauer-Platz 1 // 45891 Gelsenkirchen


== Bayern ==

$Allianz$ Arena, 66_016, 2005,  München             # FC Bayern München
  | München Fußball Arena       # euro 2024 name
  | Fußball Arena München       # euro 2024 name
  | Munich Football Arena [en]  # euro 2024 name
  Werner-Heisenberg-Allee 25 // 80939 München
TXT

    pp recs

#    assert_equal 6, recs.size

     assert_equal 'Olympiastadion',     recs[0].name
     assert_equal 'Berlin',             recs[0].city
     assert_equal 'Germany',            recs[0].country.name

     assert_equal 'Alte Försterei',     recs[1].name
     assert_equal 'Berlin',             recs[1].city
     assert_equal 'Germany',            recs[1].country.name
  end
end # class TestGroundReader
