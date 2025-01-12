## pulls in
require 'cocos'
require 'season/formats'  # e.g. Season() support machinery




####
# try a (simple) tokenizer/parser with regex

## note - match line-by-line
#            avoid massive backtracking by definition
#             that is, making it impossible

## sym(bols) -
##  text - change text to name - why? why not?


require_relative 'parser/version'
require_relative 'parser/token-score'
require_relative 'parser/token-date'
require_relative 'parser/token-text'
require_relative 'parser/token-status'
require_relative 'parser/token'
require_relative 'parser/lang'
require_relative 'parser/parser'

require_relative 'parser/opts'


####
##  todo/check - move outline reader upstream to cocos - why? why not?
##       use  read_outline(), parse_outline()  - why? why not?
require_relative 'parser/outline_reader'



###
#  make parser api (easily) available - why? why not?

=begin
module SportDb
   def self.parser() @@parser ||= Parser.new; end
   def self.parse( ... )
   end
   def self.tokenize( ... )
   end
end  # module SportDb
=end



module SportDb
class Tokenizer  
    
   attr_reader :tokens
 
   def initialize( txt )
      parser = Parser.new
 
      tree = []
      
      lines = txt.split( "\n" )
      lines.each_with_index do |line,i|
          next if line.strip.empty? || line.strip.start_with?( '#' )
      
         puts "line >#{line}<"
         tokens = parser.tokenize( line )
         pp tokens
      
         tree << tokens
      end
 

=begin   
      ## quick hack
      ##   turn all  text tokens followed by minute token
      ##     into player tokens!!!
      ##
      ##   also auto-convert text tokens into team tokens - why? why not?
      tree.each do |tokens|
         tokens.each_with_index do |t0,idx|
            t1 = tokens[idx+1]
            if t1 && t1[0] == :minute && t0[0] == :text
                 t0[0] = :player 
            end
         end
      end
=end


      ## flatten
      @tokens = []
      tree.each do |tokens|
         @tokens += tokens 
         @tokens  << [:newline, "\n"]   ## auto-add newlines
      end
 
      ## convert to racc format
      @tokens = @tokens.map do |tok|
           if tok.size == 1
             [tok[0].to_s, tok[0].to_s]
           elsif tok.size == 2
 #############
 ## pass 1
 ##   replace all texts with keyword matches (e.g. group, round, leg, etc.)
               if tok[0] == :text
                  text = tok[1]
                  tok = if parser.is_group?( text )
                          [:group, text]
                        elsif parser.is_round?( text ) || parser.is_leg?( text )
                          [:round, text]
                        else
                          tok  ## pass through as-is (1:1)
                        end
               end
 ## pass 2
        [tok[0].upcase.to_sym, tok[1]]
       else
              raise ArgumentError, "tokens of size 1|2 expected; got #{tok.pretty_inspect}"
           end
      end
   end
 
 
   def next_token
      @tokens.shift
   end
 end  # class Tokenizer
end # module SportDb


puts SportDb::Module::Parser.banner    # say hello

