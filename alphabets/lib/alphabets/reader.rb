
class Alphabet
class Reader   ## todo/check: rename to CharReader or something - why? why not?

  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    h = {}  ## char(acter) table mappings

    txt.each_line do |line|
      line = line.strip

      next if line.empty?
      next if line.start_with?( '#' )   ## skip comments too

      ## strip inline (until end-of-line) comments too
      ##  e.g  ţ  t  ## U+0163
      ##   =>  ţ  t
      line = line.sub( /#.*/, '' ).strip
      ## pp line

      values = line.split( /[ \t]+/ )
      ## pp values

      ## check - must be a even - a multiple of two
      if values.size % 2 != 0
        puts "** !!! ERROR !!! - missing mapping pair - mappings must be even (a multiple of two):"
        pp values
        exit 1
      end

      # add mappings in pairs
      values.each_slice(2) do |slice|
        ## pp slice
        key   = slice[0]
        value = slice[1]

        ## check - key must be a single-character/letter in unicode
        if key.size != 1
          puts "** !!! ERROR !!! - mapping character must be a single-character, size is #{key.size}"
          pp slice
          exit 1
        end

        ## check - check for duplicates
        if h[ key ]
          puts "** !!! ERROR !!! - duplicate mapping character; key already present"
          pp slice
          exit 1
        else
          h[ key ] = value
        end
      end
    end
    h
  end # method parse

end # class Reader
end # class Alphabet
