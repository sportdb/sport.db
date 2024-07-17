module Rsssf
class Parser
    

## transforms
##
##  Netherlands  1-2 (1-1)   England
##   =>  text => team  
##       score|vs  
##       text => team



##
##
##  add !!!!
##   collect_until e.g. collect_until( :text )


def parse_with_errors( line, debug: false )
    errors = []
    tokens, token_errors = tokenize_with_errors( line )
    errors += token_errors


=begin
#############
## pass 1 
##   replace all texts with keyword matches (e.g. group, round, leg, etc.)
     tokens = tokens.map do |t|
                      if t[0] == :text
                          text = t[1]
                          if is_group?( text )
                             ### expects to be followed by num (or text ABC??)
                             [:group, text]   
                          elsif is_matchday?( text )
                             ### expects to be followed by num
                             ##  use different name e.g. :fix_round or such?
                             [:matchday, text]   
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
=end

## transform tokens into (parse tree/ast) nodes    
    nodes = []
    
    ## note - (re)use token buffer from "standard" parser here !!!!
    buf = SportDb::Parser::Tokens.new( tokens )
    ## pp buf


    loop do 
          if buf.match?( :text, [:score, 
                                 :score_awd,
                                 :score_abd,
                                 :score_ppd,
                                 :score_np,
                                 :score_wo,
                                 :vs], :text )
             nodes << [:team, buf.next[1]]
             nodes << buf.next
             nodes << [:team, buf.next[1]]
          elsif buf.match?( :text, :minute )    ## assume player+minute
             nodes << [:player, buf.next[1]]
             nodes << buf.next
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
end  # module Rsssf
    
