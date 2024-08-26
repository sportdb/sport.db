
module SportDb
module Import


class ClubPropsReader

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

  def parse
    recs = parse_csv( @txt )
    recs.each do |rec|
      name = rec['Name']
      if name.nil?
        puts "** !!! ERROR !!! Name column required / missing / NOT found in row:"
        pp rec
        exit 1
      end

      ## find / match club by (canocial) name
      m = Club.match( name )
      if m.size > 1
        puts "** !!! WARN !!! ambigious (multiple) club matches (#{m.size}) for name >#{name}< in props row:"
        pp rec
        pp m

        ## todo/fix:  try filter by canonical name if more than one match
        m = m.select { |club| club.name == name }
      end

      if m.empty?
        puts "** !!! ERROR !!! no club match for (canonical) name >#{name}< in props row:"
        pp rec
        exit 1
      elsif m.size > 1
        puts "** !!! ERROR !!! ambigious (multiple) club matches (#{m.size}) for (canonical) name >#{name}< in props row:"
        pp rec
        pp m
        exit 1
      else   ## assume size == 1, bingo!!!
        club_rec = m[0]
        ## todo/fix:  warn if name differes from (canonical) name
        ## todo/fix:  also add props to in-memory structs/records!!!
        ## todo/fix:   only updated "on-demand" from in-memory struct/records!!!!

        ##  update attributes
        club_rec.key  = rec['Key']      if is_not_na?( rec['Key'] )
        club_rec.code = rec['Code']     if is_not_na?( rec['Code'] )
        ## todo/fix: add (some) more props e.g. address, web, etc.
      end
    end
  end # method parse


  ## allow various values for nil or n/a (not available/applicable) for now
  ##  add more or less - why? why not?
  def is_not_na?( col ) !is_na?( col); end   ## check: find a better name - why? why not?

  NA_VARIANTS = ['-', '--', '---',
                 '?', '??', '???',
                 '_', '__', '___',
                 'na', 'n/a',
                 'nil', 'null']

  def is_na?( col )
    col.nil? || col.empty? || NA_VARIANTS.include?( col.downcase )
  end


end # class ClubPropsReader

end ## module Import
end ## module SportDb
