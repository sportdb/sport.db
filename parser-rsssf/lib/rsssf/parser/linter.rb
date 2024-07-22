
module Rsssf
class Parser

###
## note - Linter for now nested inside Parser - keep? why? why not?
class Linter
   
def self.debug=(value) @@debug = value; end
def self.debug?() @@debug ||= false; end  ## note: default is FALSE
def debug?()  self.class.debug?; end   
    



attr_reader :errors

def initialize
  @errors = []
  @parser = Parser.new   ## use own parser instance (not shared) - why? why not?
end


def errors?() @errors.size > 0; end



def read( path, parse: false )
     parse( read_text( path ), parse: parse,
                               path:  path )
end

#########
## parse - false (default) - tokenize (only)
##       - true            - tokenize & parse                
##
## todo/fix - change path to file or such - why? why not?


MAX_ERRORS = 13   ## stop after 13 errors

def parse( txt, parse: false, 
                path: 'path/to/filename/here' )
  ## note: every (new) read call - resets errors list to empty
  @errors = []

  nodes = SportDb::OutlineReader.parse( txt ) 

  ##  process nodes
  h1         = nil
  orphans    = 0    ## track paragraphs with no heading
  paragraphs = 0    ## track paragraphs with heading

  nodes.each do |node|
    type = node[0]
    
    if type == :h1
        h1 = node[1]  ## get heading text
        ## puts
        puts "  = Heading 1 >#{node[1]}<"
    elsif type == :p

      if h1.nil?
        orphans += 1    ## only warn once (at the end; see below)
        next
      end

      paragraphs += 1

      lines = node[1]

      tree = [] 
      lines.each_with_index do |line,i|
     
        if debug?
          puts
          puts "line >#{line}<"
        end

        t, error_messages  =  if parse
                                @parser.parse_with_errors( line )
                              else
                                @parser.tokenize_with_errors( line )                   
                              end
         

    if error_messages.size > 0
      ## add to "global" error list
      ##   make a triplet tuple (file / msg / line text)
            error_messages.each do |msg|

                ## note - stop processing / adding errors if hit MAX ERRORS 
                if @errors.size >= MAX_ERRORS
                   @errors << [ path,
                                 "stop after #{MAX_ERRORS} errors", 
                                 '']
                   return
                end

                @errors << [ path,
                             msg,
                             line
                           ]
            end
    end

    pp t   if debug?

    tree << t
  end    
  ## pp tree
else
  pp node
  raise ArgumentError, "unsupported (node) type >#{type}<"
end
end  # each node

  ## no heading and no orphans => assume empty file (comments only)!!!
  if h1.nil? && orphans == 0
    puts "  !! WARN - no heading(s) and paragraph(s) found"
     @errors << [ path,
                  "warn - no heading(s) and paragraph(s) found",
                  ""  ## pass along empty line
                ]
  end

  if orphans > 0
    puts "  !! WARN - no heading for #{orphans} text paragraph(s); skipping parse"
    @errors << [ path,
                  "warn - no heading for #{orphans} text paragraph(s); skipping parse",
                  ""  ## pass along empty line
               ]
  end

  if h1 && paragraphs == 0
    puts "  !! WARN - heading with no text paragraph(s)"
    @errors << [ path,
                  "warn - heading with no text paragraph(s)",
                  ""  ## pass along empty line
               ]
  end

end  # parse
end  # class Linter


end   # class Parser
end   # module Rsssf