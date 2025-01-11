require 'treetop'

Treetop.load_from_string <<-END
  grammar Arithmetic
    rule expression
      [0-9]+ / '(' expression ')'
    end
  end
END

pp ArithmeticParser


parser = ArithmeticParser.new
pp parser


result = parser.parse('1 + 2')
puts result

puts "---"

pp result

puts "bye"