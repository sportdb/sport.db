# encoding: utf-8

module SportDb

class OutlineReader

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

    @txt.each_line do |line|
        line = line.strip      ## todo/fix: keep leading and trailing spaces - why? why not?

        next if line.empty?    ## todo/fix: keep blank line nodes e.g. just remove comments and process headings?! - why? why not?
        break if line == '__END__'

        next if line.start_with?( '#' )   ## skip comments too
        ## strip inline (until end-of-line) comments too
        ##  e.g Eupen | KAS Eupen ## [de]
        ##   => Eupen | KAS Eupen
        ##  e.g bq   Bonaire,  BOE        # CONCACAF
        ##   => bq   Bonaire,  BOE
        line = line.sub( /#.*/, '' ).strip
        pp line

        next if HEADING_BLANK_RE.match( line )  # skip "decorative" only heading e.g. ========

         ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
        if m=HEADING_RE.match( line )
           heading_marker = m[:marker]
           heading_level  = m[:marker].length   ## count number of = for heading level
           heading        = m[:text].strip

           puts "heading #{heading_level} >#{heading}<"
           outline << [:"h#{heading_level}", heading]
        else
           ## assume it's a (plain/regular) text line
           outline << [:l, line]
        end
    end
    outline
  end # method read
end # class OutlineReader

end # module SportDb
