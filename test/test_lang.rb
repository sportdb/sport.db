# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_lang.rb
#  or better
#     rake -I ./lib test

require 'helper'

class TestLang < MiniTest::Unit::TestCase

  def test_getters

     lang = SportDb::Lang.new

     group = 'Group'

     round = 'Round'
     round << '|Matchday'
     round << '|Round of 32|Last 32'
     round << '|Round of 16|Last 16'
     round << '|Quarterfinals|Quarter-finals|Quarters|Quarterfinal'
     round << '|Semifinals|Semi-finals|Semis'
     round << '|Third-place play-off|Third place play-off|Third place|3rd place match'
     round << '|Final|Finals'

     knockout_round = 'Round of 32|Last 32'
     knockout_round << '|Round of 16|Last 16'
     knockout_round << '|Quarterfinals|Quarter-finals|Quarters|Quarterfinal'
     knockout_round << '|Semifinals|Semi-finals|Semis'
     knockout_round << '|Third-place play-off|Third place play-off|Third place|3rd place match'
     knockout_round << '|Final|Finals'


     assert( group == lang.group )
     assert( round == lang.round )
     assert( knockout_round == lang.knockout_round )

     # NB: call twice to test caching with ||=
     assert( group == lang.group )
     assert( round == lang.round )
     assert( knockout_round == lang.knockout_round )

  end
  
  def test_getters_de
     lang = SportDb::Lang.new
     lang.lang = 'de'

     group = 'Gruppe'

     round = 'Runde'
     round << '|Spieltag'
     round << '|Sechzehntelfinale|1/16 Finale'
     round << '|Achtelfinale|1/8 Finale'
     round << '|Viertelfinale|1/4 Finale'
     round << '|Halbfinale|Semifinale|1/2 Finale'
     round << '|Spiel um Platz 3'
     round << '|Finale|Endspiel'

     knockout_round = 'Sechzehntelfinale|1/16 Finale'
     knockout_round << '|Achtelfinale|1/8 Finale'
     knockout_round << '|Viertelfinale|1/4 Finale'
     knockout_round << '|Halbfinale|Semifinale|1/2 Finale'
     knockout_round << '|Spiel um Platz 3'
     knockout_round << '|Finale|Endspiel'


     assert( group == lang.group )
     assert( round == lang.round )
     assert( knockout_round == lang.knockout_round )

     # NB: call twice to test caching with ||=

     assert( round == lang.round )
     assert( group == lang.group )
     assert( knockout_round == lang.knockout_round )
  end

  def test_regex_knockout_round
     lang = SportDb::Lang.new

     lines = [
      '(4) Quarter-finals',
      '(5) Semi-finals',
      '(6) Final'
     ]
     
     lines.each do |line|
       assert( line =~ lang.regex_knockout_round )
     end

  end
  
  def test_regex_knockout_round_de
    lang = SportDb::Lang.new
    lang.lang = 'de'

    lines = [
      '(1)  Achtelfinale              // Di+Mi 14.+15. & 21.+22. Feb 2012',
      '(2)  Achtelfinale Rückspiele   // Di+Mi 6.+7. & 13.+14. März 2012',
      '(3)  Viertelfinale             // Di+Mi 27.+28. März 2012',
      '(4)  Viertelfinale Rückspiele  // Di+Mi 3.+4.   April 2012',
      '(5)  Halbfinale                // Di+Mi 17.+18. April 2012',
      '(6)  Halbfinale Rückspiele     // Di+Mi 24.+25. April 2012',
      '(7)  Finale                    // Sa 19. Mai 2012'
    ]

     lines.each do |line|
       assert( line =~ lang.regex_knockout_round )
     end

  end

end # class TestLang