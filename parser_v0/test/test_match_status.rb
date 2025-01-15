###
#  to run use
#     ruby test/test_match_status.rb


require_relative 'helper'

class TestMatchStatus < Minitest::Test


def test_tokenize


txt =<<TXT
## examples from league starter - mauritius

  Cercle de Joachim      -   AS Port-Louis 2000    [abandoned in 24' due to bad weather]
  Cercle de Joachim     2-0  AS Port-Louis 2000    [replay]
  Pamplemousses         3-0  La Cure Sylvester      [awarded; originally 1-3, La Cure Sylvester fielded ineligible players]
  AS Port-Louis 2000    3-0  Rivière du Rempart     [awarded; originally 2-0]
  Chamarel SC           0-3  AS Port-Louis 2000     [awarded; originally 2-2]
  Cercle de Joachim      -  Rivière du Rempart    [abandoned at 0-0 in 5' due to bad weather]
  Cercle de Joachim     2-1  Rivière du Rempart   [replay]
  ASPL 2000                    3-0  GRSE Wanderers    [awarded]
  Pamplemousses                 -   Savanne              [abandoned in 10' due to unplayable pitch]
  Pamplemousses                5-3  Savanne  [replay]
  Cercle de Joachim         7-6 pen (0-0)  AS Vacoas-Phoenix   [annulled because no extra time was played]
  Cercle de Joachim            3-2 aet  AS Vacoas-Phoenix     [replay]
TXT

lines = txt.split( "\n" )
pp lines

tokens = []
lines.each_with_index do |line,i|
  puts
  puts "line #{i+1}/#{lines.size}  >#{line}<"
  ## skip blank or comment lines
  next if line.strip.empty? || line.strip.start_with?( '#' )

  t = tokenize( line )
  pp t
  tokens << t
end

pp tokens

end
end   # class TestMatchStatus

