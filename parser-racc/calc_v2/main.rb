


require_relative 'tokenizer'
require_relative 'parser'


class CalculatorParser
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



###
# test tokenize
tok = Tokenizer.new( "(1 + 2) * (3 + 4)" )
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token
pp tok.next_token

puts "---"



def evaluate(expression)
  parser = CalculatorParser.new(expression)
  result = parser.parse
  result
end


# Example usage
expressions = [
  "3 + 5",
  "10 - 2 * 3",
  "(1 + 2) * (3 + 4)",
  "20 / 4 + 2",
  "-20 / 4 + 2",
  "- 20 / 4 + 2",
 ## "!!!!",
]

expressions.each do |expr|
  result = evaluate(expr)
  puts "#{expr} = #{result}"
end

puts "bye"