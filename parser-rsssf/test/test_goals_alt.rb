###
#  to run use
#     ruby test/test_goals_alt.rb


require_relative 'helper'




class TestGoalsAlt < Minitest::Test

###
## try alternate format/style
##    minutes before  player (name/text)  - keep - why? why not?

def test_minutes_first
  lines = {

  ## deutschland/2010-11/cup.txt
 ##  (18' Draxler, 22' Huntelaar, 42' Höwedes, 55' Jurado, 70' Huntelaar)

  "   18' Draxler      " => [[:minute, "18'"], [:text, "Draxler"]],
  "18' Draxler" => [[:minute, "18'"], [:text, "Draxler"]],
  "   18 Draxler  " => [[:minute, "18"], [:text, "Draxler"]],
  "18 Draxler"      => [[:minute, "18"], [:text, "Draxler"]],
  " 18' Draxler, 22' Huntelaar, 42' Höwedes  " => 
    [[:minute, "18'"],[:text, "Draxler"],[:","],
     [:minute, "22'"],[:text, "Huntelaar"],[:","],
     [:minute, "42'"],[:text, "Höwedes"]],
  "18' Draxler, 22' Huntelaar, 42' Höwedes" => 
    [[:minute, "18'"],[:text, "Draxler"],[:","],
     [:minute, "22'"],[:text, "Huntelaar"],[:","],
     [:minute, "42'"],[:text, "Höwedes"]],
  "18 Draxler, 22 Huntelaar, 42 Höwedes" => 
    [[:minute, "18"],[:text, "Draxler"],[:","],
     [:minute, "22"],[:text, "Huntelaar"],[:","],
     [:minute, "42"],[:text, "Höwedes"]],
  }
 
  ## note - wrap line in [] for "inside" mode!!!!
  lines.each do |line,exp|
    puts "==> >#{line}<"
    t = tokenize( "[#{line}]" )
    pp t
    assert_equal exp, t

    ## try again with ()
    t = tokenize( "(#{line})" )
    pp t
    assert_equal exp, t
  end
end

end # class TestGoalsAlt

  