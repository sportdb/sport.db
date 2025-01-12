####
#  to run use:
#    $ ruby ./fbtok2.rb  (in /fbtxt)

$LOAD_PATH.unshift( '../lib' )
require 'sportdb/parser'


require_relative 'parser'


class MatchParser
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
     do_parse
  end

  def on_error(*args)
    puts "!! on error:"
    puts "args=#{args.pretty_inspect}"
  end

=begin
on_error do |error_token_id, error_value, value_stack|
    puts "Parse error on token: #{error_token_id}, value: #{error_value}"
end
=end
end 



###
## note - Linter for now nested inside Parser - keep? why? why not?
class Linter

def self.debug=(value) @@debug = value; end
def self.debug?() @@debug ||= false; end  ## note: default is FALSE
def debug?()  self.class.debug?; end



attr_reader :errors

def initialize
  @errors = []
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
def read( path )
  ## note: every (new) read call - resets errors list to empty
  @errors = []

  nodes = SportDb::OutlineReader.read( path )

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

       txt  = []
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

        txt << line
        txt << "\n"
      end

      ## flatten
      txt = txt.join
      pp txt   if debug?

      parser = MatchParser.new( txt )   ## use own parser instance (not shared) - why? why not?
      tree = parser.parse
    else
        pp node
        raise ArgumentError, "unsupported (node) type >#{type}<"
    end
  end  # each node
end  # read
end  # class Linter









###############################################
#  start with code



args = ARGV
 

opts = {
    debug: true,
}

parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{$PROGRAM_NAME} [options] PATH"


  parser.on( "-q", "--quiet",
             "less debug output/messages - default is (#{!opts[:debug]})" ) do |debug|
    opts[:debug] = false
  end
  parser.on( "--verbose", "--debug",
               "turn on verbose / debug output (default: #{opts[:debug]})" ) do |debug|
    opts[:debug] = true
  end
end
parser.parse!( args )

puts "OPTS:"
p opts
puts "ARGV:"
p args


## todo/check - use packs or projects or such
##                instead of specs - why? why not?
   paths = if args.empty?
             [
               '../../../openfootball/euro/2021--europe/euro.txt',
               '../../../openfootball/euro/2024--germany/euro.txt',
             ]
          else
            ## check for directories
            ##   and auto-expand
            SportDb::Parser::Opts.expand_args( args )
          end




errors = []
linter = Linter.new

paths.each_with_index do |path,i|

  puts "==> [#{i+1}/#{paths.size}] reading >#{path}<..."

  linter.read( path )
end

puts "bye"




__END__
   if errors.size > 0
      puts
      pp errors
      puts
      puts "!!   #{errors.size} parse error(s) in #{paths.size} datafiles(s)"
   else
      puts
      puts "OK   no parse errors found in #{paths.size} datafile(s)"
   end

   ## add errors to rec via rec['errors'] to allow
   ##   for further processing/reporting
   rec['errors'] = errors
end


