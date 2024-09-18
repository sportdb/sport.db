
module SportDb
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



  ## note:  colon (:) MUST be followed by one (or more) spaces
  ##      make sure mon feb 12 18:10 will not match
  ##        allow 1. FC Köln etc.
  ##               Mainz 05:
  ##           limit to 30 chars max
  ##          only allow  chars incl. intl buut (NOT ()[]/;)
  ##
  ##   Group A:
  ##   Group B:   - remove colon
  ##    or lookup first

  ATTRIB_RE = %r{^
                   [ ]*?     # slurp leading spaces
                (?<key>[^:|\]\[()\/; -]
                       [^:|\]\[()\/;]{0,30}
                 )
                   [ ]*?     # slurp trailing spaces
                   :[ ]+
                (?<value>.+)
                    [ ]*?   # slurp trailing spaces
                   $
                }ix


#########
## parse - false (default) - tokenize (only)
##       - true            - tokenize & parse
def read( path, parse: false )
  ## note: every (new) read call - resets errors list to empty
  @errors = []

  nodes = OutlineReader.read( path )

  ##  process nodes
  h1 = nil
  h2 = nil
  orphans = 0    ## track paragraphs's with no heading

  attrib_found = false


  nodes.each do |node|
    type = node[0]

    if type == :h1
        h1 = node[1]  ## get heading text
        puts "  = Heading 1 >#{node[1]}<"
    elsif type == :h2
        if h1.nil?
          puts "!! WARN - no heading for subheading; skipping parse"
          next
        end
        h2 = node[1]  ## get heading text
        puts "  == Heading 2 >#{node[1]}<"
    elsif type == :p

       if h1.nil?
         orphans += 1    ## only warn once
         puts "!! WARN - no heading for #{orphans} text paragraph(s); skipping parse"
         next
       end

       lines = node[1]

       tree = []
       lines.each_with_index do |line,i|

        if debug?
         puts
         puts "line >#{line}<"
        end


        ## skip new (experimental attrib syntax)
        if attrib_found == false &&
            ATTRIB_RE.match?( line )
          ## note: check attrib regex AFTER group def e.g.:
          ##         Group A:
          ##         Group B:  etc.
          ##     todo/fix - change Group A: to Group A etc.
          ##                       Group B: to Group B
           attrib_found = true
           ## logger.debug "skipping key/value line - >#{line}<"
           next
        end

        if attrib_found
          ## check if line ends with dot
          ##  if not slurp up lines to the next do!!!
          ## logger.debug "skipping key/value line - >#{line}<"
          attrib_found = false   if line.end_with?( '.' )
              # logger.debug "skipping key/value line (cont.) - >#{line}<"
              next
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
    else
        pp node
        raise ArgumentError, "unsupported (node) type >#{type}<"
    end
  end  # each node
end  # read
end  # class Linter


end   # class Parser
end   # module SportDb
