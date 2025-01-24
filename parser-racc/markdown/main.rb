
require 'cocos'
require 'strscan'

require_relative 'parser'


class Tokenizer

## line-by-line
   # Catch-all for any plain text, which would be just sequences of characters (spaces, letters, etc.)
   TEXT    = /[^\n]+/

   LIST_MARKER = /^[ ]*
                     -
                 /x

   HEADING_MARKER = /^[ ]*
                      \#{1,3}
                  /x

    WHITESPACE = /[ \t]+/              
    NEWLINE  = /\n/


    def initialize( txt )
      @ss = StringScanner.new( txt )
    end

    def next_token
      loop do
        return if @ss.eos?

        t = case
            when @ss.scan(NEWLINE)     then nil   ## skip
            when @ss.scan(WHITESPACE)  then nil   ## skip
            when text = @ss.scan( LIST_MARKER )    then [text.strip, text.strip]
            when text = @ss.scan( HEADING_MARKER ) then [text.strip, text.strip]
            when text = @ss.scan( TEXT )           then [:TEXT, text]
            else
               raise ArgumentError, "unknown input"
            end
        return t   if t
      end
    end
end   # class Tokenizer


txt = read_text( './sample.md')
puts txt

tokenizer = Tokenizer.new( txt )
loop do 
    t = tokenizer.next_token
    pp t
    break if t.nil?
end



class MarkdownParser < Racc::Parser
    def initialize( tokenizer )
      @tokenizer = tokenizer
    end
    def next_token() @tokenizer.next_token; end

    def parse() do_parse; end
end


parser = MarkdownParser.new( Tokenizer.new( txt ) )
pp parser.parse


puts "bye"