require 'treetop'




# Load the grammar from the file
Treetop.load( 'sandbox/arithmetic.tt' )


def evaluate(expression)
  # Create a parser instance
  parser = ArithmeticParser.new
  pp parser 

  # Parse the expression
  tree = parser.parse(expression)
  pp tree

  # Check if the parsing failed
  if tree.nil?
    raise "Parse error at offset: #{parser.index}"
  end

  # Evaluate the parsed expression
  # tree.value
  '?'
end


# Example usage
expressions = [
  "3 + 5",
  "10 - 2 * 3",
  "(1 + 2) * (3 + 4)",
  "20 / 4 + 2"
]

expressions.each do |expr|
  puts "#{expr} = #{evaluate(expr)}"
end


puts "bye"