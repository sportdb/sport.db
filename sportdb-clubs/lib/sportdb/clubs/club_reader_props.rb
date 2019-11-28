# encoding: utf-8


module SportDb
module Import


class ClubPropsReader

   ## shortcut convenience helper
   ##  note: uses config via "central" ClubReader!!! allows "easy" reconfig
   ## todo/fix:   move config to shared/central/all-in-one-place  SportDb::Import::Club.config - why? why not?
  def self.config() ClubReader.config; end


  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    recs = parse_csv( txt )
    recs.each do |rec|
      name = rec[:name]
      if name.nil?
        puts "** !!! ERROR !!! Name column required / missing / NOT found in row:"
        pp rec
        exit 1
      end

      ## find / match club by (canocial) name
      m = config.clubs.match( name )
      if m && m.size > 1
        puts "** !!! WARN !!! ambigious (multiple) club matches (#{m.size}) for name >#{name}< in props row:"
        pp rec
        pp m

        ## todo/fix:  try filter by canonical name if more than one match
        m = m.select { |club| club.name == name }
        m = nil    if m.empty?     ## note: reset to nil if no more matches
      end

      if m.nil?
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
        club_rec.key  = rec[:key]      if rec[:key]
        club_rec.code = rec[:code]     if rec[:code]
        ## todo/fix: add (some) more props e.g. address, web, etc.
      end
    end
  end # method parse

end # class ClubPropsReader

end ## module Import
end ## module SportDb
