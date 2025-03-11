####
#  to run use:
#    $ ruby sandbox/test_geo.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'


TEXT_RE = SportDb::Lexer::GEO_TEXT_RE


texts = [## try teams
         "Achilles'29 II",
         "UDI'19/Beter Bed",
         "UDI '19/Beter Bed",
         "One/Two",
         "One / Two",
         "One-Two",
         "One - Two",
         "V. Köln",
         "V Köln",
         "Naval 1° de Maio",
         "Achilles'29 II v UDI'19/Beter Bed",  ## only match up to v!!!!
         "Qingdao Pijiu (Beer)",
         "August 1st (Army Team)",

         "ASC Monts d'Or Chasselay",
         "Grenoble Foot 38",

         ## try rounds
         "2. Aufstieg 1. Phase",
         "2. Aufstieg 2. Phase",
         "2. Aufstieg 3. Phase",
         "Direkter Aufstieg",
         "Direkter Abstieg",
         "Zwischenrunde Gr. B",
         "5. Platz",
         "7. Platz",
         "9. Platz",
         "11. Platz",

         "2. Aufstieg 3.12",

         ## more weird rounds
         "5.-8. Platz Playoffs",
         "9.-12. Platz Playoffs",
         "13.-16. Platz Playoffs",

         ## check more 
         "Park21-Arena Gurten",
         "motion_invest Arena",
         "motion _ invest Arena",  ## FAIL -  allow "free-standing" underscore (_) - why?
         "motion_ invest Arena",   ## FAIL
         "Sport- und Freizeitzentrum Traiskirchen",
         "K's Denki Stadium",

         "'s Gravenwezel-Schilde",

         ### check dash ( - )
         "Final - First Leg",
         "ITA - FRA",

         ### check how to deal with Cheshire Silk 106.9 Stadium
         "Cheshire Silk 106.9 Stadium",
         "Cheshire Silk 106 9 Stadium",
         "Cheshire Silk 106_9 Stadium",
         ]


texts.each do |text|
  puts "==> #{text}"
  m=TEXT_RE.match( text )
  print "  "
  pp m

  if m.nil? || text != m[0]
     puts "!! text NOT matching"
  end
end


puts "bye"