# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_lang.rb
#  or better
#     rake -I ./lib test

require 'helper'

class TestLang < MiniTest::Unit::TestCase

  def test_getters

     lang = SportDb.lang
     lang.lang = 'en'

     group = 'Group'

     round = 'Round|Matchday'
     round << '|Round of 32|Last 32'
     round << '|Round of 16|Last 16|8th finals'
     round << '|Quarterfinals|Quarter-finals|Quarters|Quarterfinal|Last 8'
     round << '|Semifinals|Semi-finals|Semis|Last 4'
     round << '|Fifth place match|Fifth place|5th place match|5th place final|5th place|Match for fifth place|Match for 5th place'
     round << '|Third place match|Third-place match|Third place|3rd place match|3rd place final|3rd place|Match for third place|Match for 3rd place|Third-place play-off|Third place play-off'
     round << '|Final|Finals'
     round << '|Playoff|Playoffs|Play-off|Play-offs|Play-off for quarter-finals'

     knockout_round = 'Round of 32|Last 32'
     knockout_round << '|Round of 16|Last 16|8th finals'
     knockout_round << '|Quarterfinals|Quarter-finals|Quarters|Quarterfinal|Last 8'
     knockout_round << '|Semifinals|Semi-finals|Semis|Last 4'
     knockout_round << '|Fifth place match|Fifth place|5th place match|5th place final|5th place|Match for fifth place|Match for 5th place'
     knockout_round << '|Third place match|Third-place match|Third place|3rd place match|3rd place final|3rd place|Match for third place|Match for 3rd place|Third-place play-off|Third place play-off'
     knockout_round << '|Final|Finals'
     knockout_round << '|Playoff|Playoffs|Play-off|Play-offs|Play-off for quarter-finals'

     assert_equal group, lang.group
     assert_equal round, lang.round
     assert_equal knockout_round, lang.knockout_round

     # NB: call twice to test caching with ||=
     assert_equal group, lang.group
     assert_equal round, lang.round
     assert_equal knockout_round, lang.knockout_round

  end
  
  def test_getters_de
     lang = SportDb.lang
     lang.lang = 'de'

     group = 'Gruppe'

     round = 'Spieltag|Runde'
     round << '|Sechzehntelfinale|1/16 Finale'
     round << '|Achtelfinale|1/8 Finale'
     round << '|Viertelfinale|1/4 Finale'
     round << '|Halbfinale|Semifinale|1/2 Finale'
     round << '|Spiel um Platz 5'
     round << '|Spiel um Platz 3'
     round << '|Finale|Endspiel'

     knockout_round = 'Sechzehntelfinale|1/16 Finale'
     knockout_round << '|Achtelfinale|1/8 Finale'
     knockout_round << '|Viertelfinale|1/4 Finale'
     knockout_round << '|Halbfinale|Semifinale|1/2 Finale'
     knockout_round << '|Spiel um Platz 5'
     knockout_round << '|Spiel um Platz 3'
     knockout_round << '|Finale|Endspiel'


     assert_equal group, lang.group
     assert_equal round, lang.round
     assert_equal knockout_round, lang.knockout_round

     # NB: call twice to test caching with ||=

     assert_equal group, lang.group
     assert_equal round, lang.round
     assert_equal knockout_round, lang.knockout_round
  end

  def test_regex_knockout_round
     lang = SportDb.lang
     lang.lang = 'en'

     lines = [
      '(4) Quarter-finals',
      '(5) Semi-finals',
      '(6) Final',
      '(1) Play-off 1st Leg // 11–15 October',
      '(2) Play-off 2nd Leg // 15-19 November',
      '(1) Play-off for quarter-finals',
      '(4) Match for fifth place',
      '(5) Match for third place',
      ## check for ALL UPCASE too
      '(4) QUARTER-FINALS',
      '(5) SEMI-FINALS',
      '(6) FINAL'
     ]
     
     lines.each do |line|
       assert( line =~ lang.regex_knockout_round )
     end

  end
  
  def test_regex_knockout_round_de
    lang = SportDb.lang
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