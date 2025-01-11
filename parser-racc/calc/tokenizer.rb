

class Tokenizer
  def initialize(input)
    @input = input
    @tokens = []
    tokenize
  end

  def next_token
    @tokens.shift
  end

  private

  def tokenize
    until @input.empty?
      case @input
      when /\A\s+/
        # Skip whitespace
      when /\A(\d+)/
        @tokens << [:NUMBER, $1.to_i]
      when /\A(\+)/
        @tokens << [:PLUS, $1]
      when /\A(\-)/
        @tokens << [:MINUS, $1]
      when /\A(\*)/
        @tokens << [:MULTIPLY, $1]
      when /\A(\/)/
        @tokens << [:DIVIDE, $1]
      when /\A(\()/
        @tokens << [:LPAREN, $1]
      when /\A(\))/
        @tokens << [:RPAREN, $1]
      when /\A(\!)/
        @tokens << ['!', '!']
      else
        raise "Unexpected character: #{@input[0]}"
      end
      @input = $'
    end
    @tokens << [false, false] # End of input
  end
end