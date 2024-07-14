####
#  to run use:
#    $ ruby sandbox/test_parse.rb


$LOAD_PATH.unshift( './lib' )
require 'sportdb/parser'




## transforms
##
##  Netherlands  1-2 (1-1)   England
##   =>  text => team  
##       score|vs  
##       text => team


## token iter/find better name
##  e.g. TokenBuffer/Scanner or such ??
class Tokens  
    def initialize( tokens )
        @tokens = tokens
        @pos = 0
    end

    def pos()  @pos; end  
    def eos?() @pos >= @tokens.size; end


    def include?( *types )
        pos = @pos
        ## puts "  starting include? #{types.inspect} @ #{pos}"
        while pos < @tokens.size do
            return true   if types.include?( @tokens[pos][0] )
            pos +=1
        end
        false
    end

    ## pattern e.g. [:text, [:vs,:score], :text]
    def match?( *pattern )
        ## puts "  starting match? #{pattern.inspect} @ #{@pos}"
        pattern.each_with_index do |types,offset|
            ## if single symbol wrap in array
            types = types.is_a?(Array) ? types : [types]
            return false  unless types.include?( peek(offset) )
        end
        true
    end


    ## return token type  (e.g. :text, :num, etc.)
    def cur()           peek(0); end
    ## return content (assumed to be text)
    def text(offset=0)  
        ## raise error - why? why not?
        ##   return nil?
        if peek( offset ) != :text
            raise ArgumentError, "text(#{offset}) - token not a text type"
        end
        @tokens[@pos+offset][1]  
    end


    def peek(offset=1)  
        ## return nil if eos
        if @pos+offset >= @tokens.size
            nil
        else
           @tokens[@pos+offset][0]
        end
    end

    ## note - returns complete token 
    def next
       # if @pos >= @tokens.size
       #     raise ArgumentError, "end of array - #{@pos} >= #{@tokens.size}"
       # end
       #   throw (standard) end of iteration here why? why not?

        t = @tokens[@pos]
        @pos += 1
        t
    end

    def collect( &blk )
        tokens = []
        loop do
          break if eos?  
          tokens <<  if block_given?
                        blk.call( self.next )
                     else
                        self.next
                     end
        end
        tokens
    end
end  # class Tokens



##
##
##  add !!!!
##   collect_until e.g. collect_until( :text )


def parse( line )
    errors = []
    tokens, token_errors = tokenize_with_errors( line )
    errors += token_errors

#############
## pass 1 
##   replace all texts with keyword matches (e.g. group, round, leg, etc.)
     tokens = tokens.map do |t|
                      if t[0] == :text
                          text = t[1]
                          if Names.is_group?( text )
                             [:group, text]
                          elsif Names.is_leg?( text )
                             [:leg, text]
                          elsif Names.is_round?( text )
                             [:round, text]
                          else
                              t   ## pass through as-is (1:1)
                          end
                      else
                         t
                      end
                end


    ## puts "tokens:"
    ## pp tokens

## transform tokens into (parse tree/ast) nodes    
    nodes = []
    
    buf = Tokens.new( tokens )
    ## pp buf


    loop do 
          if buf.pos == 0   
            ## check for 
            ##    group def or round def 
            if buf.match?( :round, :'|' )    ## assume round def (change round to round_def)
                      nodes << [:round_def, buf.next[1]]
                      buf.next ## swallow pipe
                      nodes += buf.collect
                      break
            end
            if buf.match?( :group, :'|' )    ## assume group def (change group to group_def)
                      nodes << [:group_def, buf.next[1]]
                      buf.next ## swallow pipe
                      ## change all text to team
                      nodes += buf.collect { |t|
                                t[0] == :text ? [:team, t[1]] : t
                               }
                      break
            end  
          end


          if buf.match?( :text, [:score, :vs], :text )
             nodes << [:team, buf.next[1]]
             nodes << buf.next
             nodes << [:team, buf.next[1]]
          elsif buf.match?( :text, :minute )
             nodes << [:player, buf.next[1]]
             nodes << buf.next
          elsif buf.cur == :'@'
               ## add all to the end as is
               ##   only change text to geo
              nodes += buf.collect  { |t|
                           t[0] == :text ? [:geo, t[1]] : t
                            } 
              break
          else
             ## pass through
             nodes << buf.next
          end

          break if buf.eos?
    end

    nodes
end


txt = <<TXT

Group A  |    Germany   Scotland     Hungary   Switzerland
Group B  |  Spain     Croatia      Italy     Albania
Group C  |  Slovenia  Denmark      Serbia    England
Group D  |  Poland    Netherlands  Austria   France
Group E  |  Belgium   Slovakia     Romania   Ukraine 
Group F  |  Turkey    Georgia      Portugal  Czech Republic



Matchday 1  |  Fri Jun/14 - Tue Jun/18   
Matchday 2  |   Wed Jun/19 - Sat Jun/22   
Matchday 3  |  Sun Jun/23 - Wed Jun/26

##
## add (inline) stage definitions 
##  why? why not?
##
## Quali         |
## Group Phase   |
## Finals        | 
##
## or (one line?)
##  Stage(s)  |  Quali    Group Phase     Finals


## add (inline)
## shortcuts
##  e.g.
##  Frankfurt  =>   Waldstadion, Frankfurt

##  or (inline)
##   venue defintion ???
##   e.g.
##  @ Frankfurt  |   @ Waldstadion 
##
##   Rapid Wien (AUT)  |   @ Hanappi Stadion, Wien
##
##   Kansas City, Kentucky  |  @ Rock Cafe Arena    44 400   (UTC-4)  ## num for capacity
##                                or use 44 000 cap. or such ? 
##   Kansas City, Kentucky (UTC-4)   |  @ Rock Cafe Arena  (44_400)     ## num for capacity
##   Kansas City, Kentucky (UTC-4)   |  @ Rock Cafe Arena,  (44_400)     ## num for capacity


Group A
Fri Jun/14
 (1)  21:00   Germany   5-1 (3-0)  Scotland     @ München
                Wirtz 10' Musiala 19' Havertz 45+1' (pen.)  Füllkrug 68' Can 90+3';  
                Rüdiger 87' (o.g.)
Sat Jun/15
 (2)  15:00    Hungary   1-3 (0-2)   Switzerland  @ Köln
                 Varga 66'; 
                 Duah 12' Aebischer 45' Embolo 90+3'


Semi-finals
Tue Jul/9

(50)  21:00    Netherlands  1-2 (1-1)   England    @ Dortmund
                  Simons 7'; Kane 18' (pen.) Watkins 90+1'

Final
Sun Jul/14
(51)   21:00   Spain  -  England         @ Berlin   

TXT

puts txt
puts


tree = []

lines = txt.split( "\n" )
lines.each_with_index do |line,i|
    next if line.strip.empty? || line.strip.start_with?( '#' )

   puts "line >#{line}<"
   nodes = parse( line )
   pp nodes

   tree << nodes
end


puts "(parse) tree:"
pp tree

puts "bye"