

module SportDb
class CsvMatchImporter

  def self.read( path, headers: nil )
    txt = File.open( path, 'r:utf-8' ) {|f| f.read }
    parse( txt, headers: headers )
  end

  def self.parse( txt, headers: nil )
    new( txt, headers: headers ).parse
  end


  def initialize( txt, headers: nil )
    @txt     = txt
    @headers = headers
  end


  def parse
    ## todo/fix: add headers options (pass throughto CsvMatchReader)
    ##    add filters too why? why not?

    ##  todo/fix:
    ##     add normalize: false/mapping: false  flag for NOT mapping club/team names
    ##       make normalize: false the default, anyways - why? why not?
    opts = {}
    opts[:headers] = @headers  if @headers

    matches = CsvMatchParser.parse( @txt, **opts )

    matches.each do |match|
      league = Import.catalog.leagues.find!( match.league )
      # pp league

      team1  = Import.catalog.teams.find_by!( name: match.team1, league: league )
      team2  = Import.catalog.teams.find_by!( name: match.team2, league: league )

      date =  Date.strptime( match.date, '%Y-%m-%d' )
      ## quick hack - for now always use 2019/20 style season
      ##   fix!!! - use league to find proper season e.g. 2019 or 2019/20 etc.

      start_year = if date.month >= 7
                     date.year
                   else
                     date.year-1
                   end

      ## note: for now always assume 2019/20 season
      season = Season.parse( '%d/%d' % [start_year, (start_year+1)%100] )
      # pp season


      event_rec = Sync::Event.find_or_create_by( league: league,
                                                 season: season )

      team1_rec = Sync::Team.find_or_create( team1 )
      team2_rec = Sync::Team.find_or_create( team2 )

      ## warn about duplicates?
      ##  note: for now only allow one (unique) match pair per team
      match_recs = Model::Match.where( event_id: event_rec.id,
                                       team1_id: team1_rec.id,
                                       team2_id: team2_rec.id ).to_a
      if match_recs.size > 0
        puts "!! #{match_recs.size} duplicate match record(s) found:"
        pp match_recs
        exit 1
      end

      ## find last pos - check if it can be nil?  yes, is nil if no records found
      max_pos = Model::Match.where( event_id: event_rec.id ).maximum( 'pos' )
      max_pos = max_pos ? max_pos+1 : 1

      rec = Model::Match.create!(
              event_id: event_rec.id,
              team1_id: team1_rec.id,
              team2_id: team2_rec.id,
              ## round_id: round_rec.id,  -- note: now optional
              pos:      max_pos,
              date:     date.to_date,
              score1:   match.score1,
              score2:   match.score2,
              score1i:  match.score1i,
              score2i:  match.score2i )

      ## todo/fix:
      ##   check if event includes teams?
      ##    if not (auto-)add teams to event.teams !!!!!!!
    end
  end # method parse

end # class CsvEventImporter
end # module SportDb
