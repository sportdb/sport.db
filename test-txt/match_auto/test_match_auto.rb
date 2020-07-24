# encoding: utf-8

###
#  to run use
#     ruby -I . match_auto/test_match_auto.rb


require 'helper'


class TestMatchAuto < MiniTest::Test

  def test_pt
    txt, exp = read_test( 'match_auto/pt/br.txt' )

    teams, rounds = parse_auto_conf( txt, lang: 'pt' )

    assert_equal exp['teams'],  teams.deep_stringify_keys
    assert_equal exp['rounds'], rounds.deep_stringify_keys
  end


  def test_de
    txt, exp = read_test( 'match_auto/de/at.txt' )

    teams, rounds = parse_auto_conf( txt, lang: 'de' )

    assert_equal exp['teams'],  teams.deep_stringify_keys
    assert_equal exp['rounds'], rounds.deep_stringify_keys
  end

  def test_es
    %w[match_auto/es/es.txt
       match_auto/es/mx.txt
      ].each do |path|
        txt, exp = read_test( path )

        puts "testing match auto conf #{path}..."
        teams, rounds = parse_auto_conf( txt, lang: 'es' )

        assert_equal exp['teams'],  teams.deep_stringify_keys
        assert_equal exp['rounds'], rounds.deep_stringify_keys
      end
  end


  def test_fr
    txt, exp = read_test( 'match_auto/fr/fr.txt' )

    teams, rounds = parse_auto_conf( txt, lang: 'fr' )

    assert_equal exp['teams'],  teams.deep_stringify_keys
    assert_equal exp['rounds'], rounds.deep_stringify_keys
  end


  def test_en
    %w[match_auto/eng.txt
       match_auto/eng_ii.txt
       match_auto/mu.txt
      ].each do |path|
       txt, exp = read_test( path )

       puts "testing match auto conf #{path}..."
       teams, rounds = parse_auto_conf( txt )

       assert_equal exp['teams'],  teams.deep_stringify_keys
       assert_equal exp['rounds'], rounds.deep_stringify_keys
    end
  end   # method test_parse

end  # class TestMatchAuto
