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

     # NB: call twice to test caching with ||=
     assert( group == lang.group )
     assert( group == lang.group )
     
     assert( round == lang.round )
     assert( round == lang.round )

     assert( knockout_round == lang.knockout_round )
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

     # NB: call twice to test caching with ||=
     assert( group == lang.group )
     assert( group == lang.group )
     
     assert( round == lang.round )
     assert( round == lang.round )

     assert( knockout_round == lang.knockout_round )
     assert( knockout_round == lang.knockout_round )
  end

end # class TestLang