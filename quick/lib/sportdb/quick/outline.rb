
module SportDb

###
#  add a simple Outline convenience class
#            for processing OUtlines with OUtlineReader
#   rename to simply Outline - why? why not?
#     todo - add more processing options - why? why not?

class Outline
   def self.read( path )
       nodes = OutlineReader.read( path ) 
       new( nodes )
   end    
   
   def self.parse( txt )
       nodes = OutlineReader.parse( txt )
       new( nodes )
   end


   def initialize( nodes )
      @nodes = nodes
   end

   def each_para( &blk )
     ## note: every (new) read call - resets errors list to empty
     ### @errors = []

     ##  process nodes
     h1 = nil
     h2 = nil
     orphans = 0    ## track paragraphs's with no heading

     @nodes.each do |node|
        type = node[0]

        if type == :h1
           h1 = node[1]  ## get heading text
           puts "  = Heading 1 >#{node[1]}<"
        elsif type == :h2
           if h1.nil?
             puts "!! WARN - no heading for subheading; skipping processing"
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
           blk.call( lines )
        else
          pp node
          raise ArgumentError, "unsupported (node) type >#{type}<"
        end
     end  # each node
   end  # each_para
   alias_method :each_paragraph, :each_para


## get all para(graphs) as text (not array of lines)
##   make default - why? why not?
#
#   design - or wrap lines into a Para class
#                       with properties  lines and text
#                          and such - why? why not?
#          downside - might be overkill/overengineered
#               just use simple txt as string (buffer) for all - why? why not?
##
##  hacky alternative - add a to_text or text method to string and array - why? why not?


   def each_para_text( &blk )   ## or use each_text or ? - why? why not=
       each_para do |lines|
           txt = lines.reduce( String.new ) do |mem,line| 
                                     mem << line; mem << "\n"; mem 
                                    end
           blk.call( txt )
       end
   end
end   # class Outline



###
#  add alternate alias - why? why not?
QuickMatchOutline = Outline


end   ## module SportDb
 