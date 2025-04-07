module SportDbV2
module Sync


  class Team
    def self.find_or_create( name: )
       rec = Model::Team.find_by( name: name )
       if rec.nil?
         attribs = { name: name }

         rec = Model::Team.create!( attribs )
       end
       rec
    end
  end # class Team

  class EventRound
    def self.find_or_create( name:, event_rec: )
       rec = Model::EventRound.find_by( name: name, event_id: event_rec.id )
       if rec.nil?
 
         attribs = { event_id: event_rec.id,
                     name:     name
                   }

         ## todo/fix:  check if round has (optional) start or end date and add!!!
         ## attribs[ :start_date] = round.start_date.to_date
         rec = Model::EventRound.create!( attribs )
       end
       rec
    end
  end # class EventRound



  class Match
    def self.create!( match, event_rec: )
       ## note: MUST find round, thus, use bang (!)

       ## todo/check: allow strings too - why? why not?


       ## todo/check:
       ##   how to model "same" rounds in different stages
       ##   e.g. Belgium
       ##    in regular season (stage) - round 1, round 2, etc.
       ##    in playoff        (stage) - round 1, round 2, etc.
       ## reference same round or create a new one for each stage!!???
       ##  and lookup by name AND stage??

       round_rec = if match.round || match.stage || match.group
                     ## note - for now use "all-in-one" super round
                     ###     stage, round, group    - is the layout
                     ## query for round - allow string or round rec
                     ## todo/fix - also allow stage.name and group.name - why? why not?
                     ##  e.g.      group_name = match.group.is_a?( String ) ? match.group : match.group.name
 
                     round_name  = match.round.is_a?( String ) ? match.round : match.round.name
                     round_name = "#{match.stage}, #{round_name}"   if match.stage
                     round_name = "#{round_name}, #{match.group}"   if match.group

                     Sync::EventRound.find_or_create( name: round_name, 
                                                      event_rec: event_rec )
                   else    # note: allow matches WITHOUT rounds too (e.g. England Football League 1888 and others)
                     nil
                   end

 

       team1_name   = match.team1.is_a?( String ) ? match.team1 : match.team1.name
       team2_name   = match.team2.is_a?( String ) ? match.team2 : match.team2.name
       team1_rec    = Team.find_or_create( name: team1_name )
       team2_rec    = Team.find_or_create( name: team2_name )

  
        rec = nil   ## match record

         attribs = { league_id: event_rec.league.id,  
                     season:    event_rec.season,
               
                     team1_id: team1_rec.id,
                     team2_id: team2_rec.id,

                     # pos:      max_pos,
                     # num:      match.num,   ## note - might be nil (not nil for euro, world cup, etc.)
                     date:     match.date,  # assume iso format as string e.g. 2021-07-10 !!!
                     time:     match.time,  # assume iso format as string e.g. 21:00 !!!
                    
                     score1ft:   match.score1,
                     score2ft:   match.score2,
                     score1ht:  match.score1i,
                     score2ht:  match.score2i,
                    
                     score1et: match.score1et,
                     score2et: match.score2et,
                     score1p:  match.score1p,
                     score2p:  match.score2p,
                     status:   match.status }

         attribs[ :event_round_id ] = round_rec.id   if round_rec
        
         rec = Model::Match.create!( attribs )
        rec
    end
  end # class Match

end # module Sync
end # module SportDbV2
