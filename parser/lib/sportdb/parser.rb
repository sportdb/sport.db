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
require_relative 'parser/tokenizer'

require_relative 'parser/lang'
require_relative 'parser/parser'


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
          ##   support for inline (end-of-line) comments
          line = line.sub(  /#.*/, '' ).strip

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

=begin
## auto-add/insert start tokens for known line patterns
##    START_GOALS for  goals_line
##    why? why not?
=end

      ## flatten
      @tokens = []
      tree.each do |tokens|
         @tokens += tokens 
         @tokens  << [:NEWLINE, "\n"]   ## auto-add newlines
      end
 

      ## convert to racc format
      @tokens = @tokens.map do |tok|
           if tok.size == 1
             [tok[0].to_s, tok[0].to_s]
           elsif tok.size == 2
 #############
 ## pass 1
 ##   replace all texts with keyword matches (e.g. group, round, leg, etc.)
               if tok[0] == :TEXT
                  text = tok[1]
                  tok = if parser.is_group?( text )
                          [:GROUP, text]
                        elsif parser.is_round?( text ) || parser.is_leg?( text )
                          [:ROUND, text]
                        else
                          tok  ## pass through as-is (1:1)
                        end
               end
 ## pass 2
              tok
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



####
#   RaccMatchParser support machinery (incl. node classes/abstract syntax tree)

class RaccMatchParser


LineupLine = Struct.new( :team, :lineup ) do
  def pretty_print( printer )
    printer.text( "<LineupLine " )
    printer.text( self.team )
    printer.text( " lineup=" + self.lineup.pretty_inspect )
    printer.text( ">" )
  end
end

Lineup     = Struct.new( :name, :card, :sub ) do
  def pretty_print( printer )
    buf = String.new
    buf <<  self.name 
    buf << " card=" + self.card.pretty_inspect    if card
    buf << " sub=" + self.sub.pretty_inspect      if sub
    printer.text( buf ) 
  end
end


Card       = Struct.new( :name, :minute ) do
  def to_s
    buf = String.new
    buf << "#{self.name}"
    buf << " #{self.minute.to_s}"   if self.minute
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  
end


Sub        = Struct.new( :minute, :sub )  do
  def pretty_print( printer )
    buf = String.new 
    buf << "(#{self.minute.to_s} " 
    buf << self.sub.pretty_inspect  
    buf << ")"
    printer.text( buf ) 
  end
end



GroupDef   = Struct.new( :name, :teams ) do
  def pretty_print( printer )
    printer.text( "<GroupDef " )
    printer.text( self.name )
    printer.text( " teams=" + self.teams.pretty_inspect )
    printer.text( ">" )
  end
end


RoundDef   = Struct.new( :name, :date, :duration )  do
  def pretty_print( printer )
    printer.text( "<RoundDef " )
    printer.text( self.name )
    printer.text( " date=" + self.date.pretty_inspect ) if date
    printer.text( " durattion=" + self.duration.pretty_inspect ) if duration
    printer.text( ">" )
  end
end

DateHeader = Struct.new( :date ) do
  def pretty_print( printer )
    printer.text( "<DateHeader " )
    printer.text( "#{self.date.pretty_inspect}>" )
  end
end

GroupHeader = Struct.new( :name ) do
  def pretty_print( printer )
    printer.text( "<GroupHeader " )
    printer.text( "#{self.name}>" )
  end
end

RoundHeader = Struct.new( :names ) do
  def pretty_print( printer )
    printer.text( "<RoundHeader " )
    printer.text( "#{self.names.join(', ')}>" )
  end
end

MatchLine   = Struct.new( :ord, :date, :time,
                          :team1, :team2, :score,
                          :status, 
                          :geo )  do   ## change to geos - why? why not?

  def pretty_print( printer )
    printer.text( "<MatchLine " )
    printer.text( "#{self.team1} v #{self.team2}")
    printer.breakable

    members.zip(values) do |name, value|
      next if [:team1, :team2].include?( name )
      next if value.nil?
      
      printer.text( "#{name}=#{value.pretty_inspect}" )
    end    

    printer.text( ">" )
  end  

end

GoalLine    = Struct.new( :goals1, :goals2 ) do
  def pretty_print( printer )
    printer.text( "<GoalLine " )
    printer.text( "goals1=" + self.goals1.pretty_inspect + "," )
    printer.breakable
    printer.text( "goals2=" + self.goals2.pretty_inspect + ">" )
  end  
end

Goal        = Struct.new( :player, :minutes ) do
  def to_s
    buf = String.new
    buf << "#{self.player}"
    buf << " "
    buf << minutes.map { |min| min.to_s }.join(' ')
    buf
  end

  def pretty_print( printer )
    printer.text( to_s )
  end  

end


##
##  fix - move :og, :pen  to Goal if possible - why? why not?
##  or change to GoalMinute ???
Minute      = Struct.new( :m, :offset, :og, :pen )  do
    def to_s
      buf = String.new
      buf << "#{self.m}"
      buf << "+#{self.offset}"  if self.offset 
      buf << "'"
      buf << "(og)"   if self.og
      buf << "(pen)"  if self.pen
      buf
    end
 
    def pretty_print( printer ) 
       printer.text( to_s ) 
    end  
end




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
     @tree = [] 
     do_parse
     @tree
  end


  def on_error(*args)
    puts
    puts "!! on parse error:"
    puts "args=#{args.pretty_inspect}"
    exit 1  ##   exit for now  -  get and print more info about context etc.!!
  end


=begin
on_error do |error_token_id, error_value, value_stack|
    puts "Parse error on token: #{error_token_id}, value: #{error_value}"
end
=end

end 


puts SportDb::Module::Parser.banner    # say hello

