# encoding: utf-8

module SportDb


class ConfLinter

  def self.config() Import.config; end    ## shortcut convenience helper


  def self.read( path )   ## use - rename to read_file or from_file etc. - why? why not?
    puts "reading conf(iguration) datafile >#{path}<..."
    txt = File.open( path, 'r:utf-8' ).read
    parse( txt )
  end

  def self.parse( txt )
    recs = LeagueOutlineReader.parse( txt )

    if recs.empty?
      puts "  ** !!! WARN !!! - no league headings found"
    else
      puts "  found #{recs.size} league (+season+stage) headings"
      recs.each do |rec|
         ## rec[:league] )
         ## rec[:season] )
         ## rec[:stage]
         puts "   league: >#{rec[:league]}<, season: >#{rec[:season]}<, stage: >#{rec[:stage]}<"
      end
    end

    ## pass 2 - check & map; replace inline (string with record)
    recs.each do |rec|
      league = rec[:league]
      clubs = []    ## convert lines to clubs
      rec[:lines].each do |line|

        next if line =~ /^[ -]+$/   ## skip decorative lines with dash only (e.g. ---- or - - - -) etc.

        scan = StringScanner.new( line )

        if scan.check( /\d{1,2}[ ]+/ )    ## entry with standaning starts with ranking e.g. 1,2,3, etc.
          puts "  table entry >#{line}<"
          rank = scan.scan( /\d{1,2}[ ]+/ ).strip   # note: strip trailing spaces

          ## note: uses look ahead scan until we hit at least two spaces
          ##  or the end of string  (standing records for now optional)
          name = scan.scan_until( /(?=\s{2})|$/ )
          if scan.eos?
            standing = nil
          else
            standing = scan.rest.strip   # note: strip leading and trailing spaces
          end
          puts "   rank: >#{rank}<, name: >#{name}<, standing: >#{standing}<"

          ## note: rank and standing gets ignored (not used) for now
        else
          ## assume club is full line
          name = line
        end

        clubs << find_club( name, league.country )
      end

      rec[:clubs] = clubs
      rec.delete( :lines )   ## remove lines entry
    end

    recs
  end # method read


  ### todo/fix: move to clubs for sharing!!!!!!!  use clubs.find_by!( name:, country: )
  def self.find_club( name, country )   ## todo/fix: add international or league flag?
    club = nil
    m = config.clubs.match_by( name: name, country: country )

    if m.nil?
      ## (re)try with second country - quick hacks for known leagues
      ##  todo/fix: add league flag to activate!!!
      m = config.clubs.match_by( name: name, country: config.countries['wal'])  if country.key == 'eng'
      m = config.clubs.match_by( name: name, country: config.countries['nir'])  if country.key == 'ie'
      m = config.clubs.match_by( name: name, country: config.countries['mc'])   if country.key == 'fr'
      m = config.clubs.match_by( name: name, country: config.countries['li'])   if country.key == 'ch'
      m = config.clubs.match_by( name: name, country: config.countries['ca'])   if country.key == 'us'
    end

    if m.nil?
      puts "** !!! ERROR !!! no match for club >#{name}<"
      exit 1
    elsif m.size > 1
      puts "** !!! ERROR !!! too many matches (#{m.size}) for club >#{name}<:"
      pp m
      exit 1
    else   # bingo; match - assume size == 1
      club = m[0]
    end

    club
  end

end # class ConfLinter
end # module SportDb
