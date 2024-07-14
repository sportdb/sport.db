module SportDb 
class Parser
    

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


def parse_with_errors( line, debug: false )
    errors = []
    tokens, token_errors = tokenize_with_errors( line, typed: true )
    errors += token_errors

#############
## pass 1 
##   replace all texts with keyword matches (e.g. group, round, leg, etc.)
     tokens = tokens.map do |t|
                      if t[0] == :text
                          text = t[1]
                          if is_group?( text )
                             [:group, text]
                          elsif is_leg?( text )
                             [:leg, text]
                          elsif is_round?( text )
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

    [nodes,errors]
end


### convience helper - ignore errors by default
def parse( line, debug: false )
  nodes, _ = parse_with_errors( line, debug: debug )
  nodes
end


end #  class Parser
end  # module SportDb 
    
