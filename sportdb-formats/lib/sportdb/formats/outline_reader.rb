# encoding: utf-8

module SportDb

class OutlineReader

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    outline=[]   ## outline structure

    txt.each_line do |line|
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

        next if line =~ /^={1,}$/          ## skip "decorative" only heading e.g. ========

         ## note: like in wikimedia markup (and markdown) all optional trailing ==== too
         ##  todo/check:  allow ===  Text  =-=-=-=-=-=   too - why? why not?
        if line =~ /^(={1,})       ## leading ======
                     ([^=]+?)      ##  text   (note: for now no "inline" = allowed)
                     =*            ## (optional) trailing ====
                     $/x
           heading_marker = $1
           heading_level  = $1.length   ## count number of = for heading level
           heading        = $2.strip

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
