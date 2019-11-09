
module DateFormats

########################
#   parse words
class Reader   ## todo/check: rename to WordReader or something for easy (re)use - why? why not?

    def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
      txt = File.open( path, 'r:utf-8' ).read
      parse( txt )
    end

    def self.parse( txt )
      lines = [] # array of lines (with words)

      txt.each_line do |line|
        line = line.strip

        next if line.empty?
        next if line.start_with?( '#' )   ## skip comments too

        ## strip inline (until end-of-line) comments too
        ##   e.g. Janvier  Janv  Jan  ## check janv in use??
        ##   =>   Janvier  Janv  Jan

        line = line.sub( /#.*/, '' ).strip
        ## pp line

        values = line.split( /[ \t]+/ )
        ## pp values

        ## todo/fix -- add check for duplicates
        lines << values
      end
      lines
    end # method parse
end # class Reader



def self.parse_month( txt )
    lines = Reader.parse( txt )
    if lines.size != 12
      puts "*** !!! ERROR !!! reading month names; got #{lines.size} lines - expected 12"
      exit 1
    end
    lines
end

def self.parse_day( txt )
    lines = Reader.parse( txt )
    if lines.size != 7
      puts "*** !!! ERROR !!! reading day names; got #{lines.size} lines - expected 7"
      exit 1
    end
    lines
end


def self.build_names( lines )
  ## join all words together into a single string e.g.
  ##   January|Jan|February|Feb|March|Mar|April|Apr|May|June|Jun|...
  lines.map { |line| line.join('|') }.join('|')
end
end # module DateFormats
