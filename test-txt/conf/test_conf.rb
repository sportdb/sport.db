###
#  to run use
#     ruby -I . conf/test_conf.rb


require 'helper'


class TestConf < Minitest::Test

  def test_conf
    %w[conf/at_cup.txt
       conf/at_reg.txt
       conf/at_champs.txt
       conf/eng.txt
       conf/champs.txt
      ].each do |path|
         txt, exp = read_test( path )

         puts "testing conf #{path}..."
         teams = parse_conf( txt )

         ## note: json always returns hash tables with string keys (not symbols),
         ##        thus, always stringify keys before comparing!!!!
         assert_equal exp, teams.deep_stringify_keys
      end
  end

end   # class TestConf
