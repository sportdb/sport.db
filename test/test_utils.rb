# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_lang.rb
#  or better
#     rake -I ./lib test

require 'helper'

class TestUtils < MiniTest::Unit::TestCase

  def test_is_group_def
    SportDb.lang.lang = 'en'

    lines = [
      'Group A |',
      'Group B |'
     ]

     reader = Reader.new

     lines.each do |line|
       assert_equal true, reader.is_group_def?( line )
     end
  end

  def test_is_group
    SportDb.lang.lang = 'en'

    lines = [
      'Group A',
      'Group A:',
      '[Group A]'
     ]

     reader = Reader.new

     lines.each do |line|
       assert_equal true, reader.is_group?( line )
     end
  end


  def test_is_round_def
    SportDb.lang.lang = 'en'

    lines = [
      'Matchday 1 |',
      'Round 1    |'
     ]

     reader = Reader.new

     lines.each do |line|
       assert_equal true, reader.is_round_def?( line )
     end
  end

  def test_is_round
    SportDb.lang.lang = 'en'

    lines = [
      'Matchday 1',
      '[Matchday 1]',
      'Matchday 1:',
      'Round 1'
     ]

     reader = Reader.new

     lines.each do |line|
       assert_equal true, reader.is_round?( line )
     end
  end


  def test_is_knockout_round
    SportDb.lang.lang = 'en'

    lines = [
      '(4) Quarter-finals',
      '(5) Semi-finals',
      '(6) Final'
     ]
    
     reader = Reader.new

     lines.each do |line|
       assert_equal true, reader.is_knockout_round?( line )
     end
  end


  def test_is_knockout_round_de
    SportDb.lang.lang = 'de'

    lines = [
      '(1)  Achtelfinale              // Di+Mi 14.+15. & 21.+22. Feb 2012',
      '(2)  Achtelfinale Rückspiele   // Di+Mi 6.+7. & 13.+14. März 2012',
      '(3)  Viertelfinale             // Di+Mi 27.+28. März 2012',
      '(4)  Viertelfinale Rückspiele  // Di+Mi 3.+4.   April 2012',
      '(5)  Halbfinale                // Di+Mi 17.+18. April 2012',
      '(6)  Halbfinale Rückspiele     // Di+Mi 24.+25. April 2012',
      '(7)  Finale                    // Sa 19. Mai 2012'
    ]

     reader = Reader.new

     lines.each do |line|
       assert_equal true, reader.is_knockout_round?( line )
     end
  end

private
  #######################
  # private helpers

  class Reader
    include LogUtils::Logging      # add logger
    include SportDb::FixtureHelpers
  end

end # class TestUtils
