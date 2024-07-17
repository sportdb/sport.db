
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



#########
## parse - false (default) - tokenize (only)
##       - true            - tokenize & parse                
def read( path, parse: false )

  ## fix - (re)use outline reader later!!!
  ##   plus check for headings etc.

  text = File.open( path, 'r:utf-8' ) { |f| f.read } 
  lines = text.split( "\n" )


  ##  process lines 
  tree = [] 
  lines.each do |line|

    ## skip blank and comment lines
    next if line.strip.empty? || line.strip.start_with?('#')

    ## strip inline (end-of-line) comments
    line = line.sub( /#.+$/, '' )


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
end  # read
end  # class Linter


end   # class Parser
end   # module Rsssf