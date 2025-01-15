###
#  to run use
#     ruby test/test_match_status_re.rb


require_relative 'helper'

class TestMatchStatusRe < Minitest::Test


def test_tokenize



txt =<<TXT
## examples from league starter - mauritius

  [abandoned in 24' due to bad weather]
  [replay]
  [awarded; originally 1-3, La Cure Sylvester fielded ineligible players]
  [awarded; originally 2-0]
  [awarded; originally 2-2]
  [abandoned at 0-0 in 5' due to bad weather]
  [replay]
  [awarded]
  [abandoned in 10' due to unplayable pitch]
  [replay]
  [annulled because no extra time was played]
  [replay]
TXT

lines = txt.split( "\n" )
pp lines

lines.each_with_index do |line,i|
  puts
  puts "line #{i+1}/#{lines.size}  >#{line}<"
  ## skip blank or comment lines
  next if line.strip.empty? || line.strip.start_with?( '#' )

  m = STATUS_RE.match( line )
  pp m
  pp m[:status]
  pp m[:status_note]
  pp m.named_captures
end


end
end   # class TestMatchStatusRe

