

module SportDb

  
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
