####
#  to run use:
#    $ ruby ./main.rb  (in /fbtxt)



$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'


require_relative 'parser'


class MatchParser
def initialize(input)
    puts "==> input:"
    puts input
    @tokenizer = SportDb::Tokenizer.new(input)
  end
  

  def next_token
    tok = @tokenizer.next_token
    puts "next_token => #{tok.pretty_inspect}"
    tok
  end
  
#  on_error do |error_token_id, error_value, value_stack|
#      puts "Parse error on token: #{error_token_id}, value: #{error_value}"
#  end  

  def parse
     puts "parse:" 
     do_parse
  end

  def on_error(*args)
    puts "!! on error:"
    puts "args=#{args.pretty_inspect}"
  end

=begin
on_error do |error_token_id, error_value, value_stack|
    puts "Parse error on token: #{error_token_id}, value: #{error_value}"
end
=end

end 




txt = <<-TXT

Oct 7 
Austria  1-2  Rapid 


Oct 7   Austria  1-2  Rapid 

Oct 11
Sturm   0-0  LASK  
Mauerbach v Spittelau

[Oct 22]
PSV - Ajax


Oct 22 12:00   PSV - Ajax

(8)  Oct 22 12:00   PSV - Ajax



##########################
#### more

Group A  |    Germany   Scotland     Hungary   Switzerland
Group B  |  Spain     Croatia      Italy     Albania
Group C  |  Slovenia  Denmark      Serbia    England
Group D  |  Poland    Netherlands  Austria   France
Group E  |  Belgium   Slovakia     Romania   Ukraine 
Group F  |  Turkey    Georgia      Portugal  Czech Republic


Matchday 1  |  Fri Jun/14 - Tue Jun/18   
Matchday 2  |   Wed Jun/19 - Sat Jun/22   
Matchday 3  |  Sun Jun/23 - Wed Jun/26



Group A
Fri Jun/14
 (1)  21:00   Germany   5-1 (3-0)  Scotland     @ München
                Wirtz 10' Musiala 19' Havertz 45+1' (pen.)  Füllkrug 68' Can 90+3';  
                Rüdiger 87' (o.g.)
Sat Jun/15
 (2)  15.00    Hungary   1-3 (0-2)   Switzerland  @ Köln
                 Varga 66'; 
                 Duah 12' Aebischer 45' Embolo 90+3'


Semi-finals
Tu July/9 2024

(50)  21h00    Netherlands  1-2 (1-1)   England    @ Dortmund
                  Simons 7'; Kane 18' (pen.) Watkins 90+1'

Final
Sunday Jul 14 2024
(51)   21.00   Spain  -  England         @ Berlin   

TXT


###
# test tokenize
tok = SportDb::Tokenizer.new( txt )
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token

puts "---"



def parse( txt )
  parser = MatchParser.new( txt )
  tree = parser.parse
  tree
end


parse( txt ) 


puts "bye"