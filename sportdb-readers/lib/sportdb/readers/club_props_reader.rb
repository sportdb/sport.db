# encoding: utf-8


module SportDb
module Import


class ClubPropsReader

  def self.config() Import.config; end    ## shortcut convenience helper

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

        ## update database
        club = Sync::Club.find_or_create( club_rec )
        ##  update attributes
        attributes = {}
        attributes[:key]  = rec[:key]      if rec[:key]
        attributes[:code] = rec[:code]     if rec[:code]

        club.attributes = attributes
        club.save!
      end
    end
  end # method parse

end # class ClubPropsReader

end ## module Import
end ## module SportDb
