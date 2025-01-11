require_relative 'tokenizer'
require_relative 'parser'


class MatchParser
def initialize(input)
    puts "==> input:"
    puts input
    @tokenizer = Tokenizer.new(input)
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
Austria 4

Oct 7 
Austria 1
Rapid 2

Oct 11
Sturm  0
LASK  3

TXT


###
# test tokenize
tok = Tokenizer.new( txt )
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