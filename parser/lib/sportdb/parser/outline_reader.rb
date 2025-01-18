

module SportDb

###
#  add a simple Outline convenience class
#            for processing OUtlines with OUtlineReader

class QuickMatchOutline
   def self.read( path )
       nodes = OutlineReader.read( path )
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
   alias_method :each_p,         :each_para
end   # class QuickMatchOutline




class OutlineReader

  def self.debug=(value) @@debug = value; end
  def self.debug?() @@debug ||= false; end
  def debug?()  self.class.debug?; end



  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt )
  end

  def self.parse( txt )
    new( txt ).parse
  end

  def initialize( txt )
    @txt = txt
  end

  ## note: skip "decorative" only heading e.g. ========
  ##  todo/check:  find a better name e.g. HEADING_EMPTY_RE or HEADING_LINE_RE or ???
  HEADING_BLANK_RE = %r{\A
                        ={1,}
                        \z}x

  ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
  HEADING_RE = %r{\A
                  (?<marker>={1,})       ## 1. leading ======
                    [ ]*
                  (?<text>[^=]+)         ## 2. text   (note: for now no "inline" = allowed)
                    [ ]*
                    =*                   ## 3. (optional) trailing ====
                  \z}x

  def parse
    outline=[]   ## outline structure
    start_para = true      ## start new para(graph) on new text line?

    @txt.each_line do |line|
        line = line.strip      ## todo/fix: keep leading and trailing spaces - why? why not?

        if line.empty?    ## todo/fix: keep blank line nodes?? and just remove comments and process headings?! - why? why not?
          start_para = true
          next
        end

        break if line == '__END__'

        next if line.start_with?( '#' )   ## skip comments too
        ## strip inline (until end-of-line) comments too
        ##  e.g Eupen | KAS Eupen ## [de]
        ##   => Eupen | KAS Eupen
        ##  e.g bq   Bonaire,  BOE        # CONCACAF
        ##   => bq   Bonaire,  BOE
        line = line.sub( /#.*/, '' ).strip
        pp line    if debug?

        ## todo/check: also use heading blank as paragraph "breaker" or treat it like a comment ?? - why? why not?
        next if HEADING_BLANK_RE.match( line )  # skip "decorative" only heading e.g. ========

         ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
        if m=HEADING_RE.match( line )
           start_para = true

           heading_marker = m[:marker]
           heading_level  = heading_marker.length   ## count number of = for heading level
           heading        = m[:text].strip

           puts "heading #{heading_level} >#{heading}<"   if debug?
           outline << [:"h#{heading_level}", heading]
        else    ## assume it's a (plain/regular) text line
           if start_para
             outline << [:p, [line]]
             start_para = false
           else
             node = outline[-1]    ## get last entry
             if node[0] == :p      ##  assert it's a p(aragraph) node!!!
                node[1] << line    ## add line to p(aragraph)
             else
               puts "!! ERROR - invalid outline state / format - expected p(aragraph) node; got:"
               pp node
               exit 1
             end
           end
        end
    end
    outline
  end # method read
end # class OutlineReader

end # module SportDb
