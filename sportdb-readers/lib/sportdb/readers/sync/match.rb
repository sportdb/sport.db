module SportDb
module Sync

  class Match
    ### todo/fix: rename to create!!   (add update support later) !!!!
    ##    use update_by_round  or update_by_date or update_by_teams or such
    ##      NO easy (unique always auto-id match) possible!!!!!!
    def self.create_or_update( match, event: )
       ## note: MUST find round, thus, use bang (!)

       ## todo/check: allow strings too - why? why not?


       ## todo/check:
       ##   how to model "same" rounds in different stages
       ##   e.g. Belgium
       ##    in regular season (stage) - round 1, round 2, etc.
       ##    in playoff        (stage) - round 1, round 2, etc.
       ## reference same round or create a new one for each stage!!???
       ##  and lookup by name AND stage??


       round_rec = if match.round
                     ## query for round - allow string or round rec
                     round_name  = match.round.is_a?( String ) ? match.round : match.round.name
                     Model::Round.find_by!( event_id: event.id,
                                            name:     round_name )
                   else    # note: allow matches WITHOUT rounds too (e.g. England Football League 1888 and others)
                     nil
                   end

       ## todo/check: allow fallback with db lookup if NOT found in cache - why? why not?
       ##  or better use Sync::Team.find_or_create( team )  !!!!!!! to auto-create on first hit!
       ##    || Team.find_or_create( team1 )  -- note: does NOT work for string (only recs) - what to do?
       ##    || Model::Team.find_by!( name: team1_name )
       team1_name   = match.team1.is_a?( String ) ? match.team1 : match.team1.name
       team1_rec    = Team.cache[ team1_name ]
       team2_name   = match.team2.is_a?( String ) ? match.team2 : match.team2.name
       team2_rec    = Team.cache[ team2_name ]

       ## check optional group (e.g. Group A, etc.)
       group_rec = if match.group
                     group_name = match.group.is_a?( String ) ? match.group : match.group.name
                     Model::Group.find_by!( event_id: event.id,
                                            name:     group_name )
                   else
                     nil
                   end

       ## check optional stage (e.g. Regular, Play Off, Relegation, etc. )
       stage_rec = if match.stage
                     stage_name = match.stage.is_a?( String ) ? match.stage : match.stage.name
                     Model::Stage.find_by!( event_id: event.id,
                                            name:     stage_name )
                   else
                     nil
                   end

       ### todo/check: what happens if there's more than one match? exception raised??
       rec = if ['N. N.'].include?( team1_name ) && ## some special cases - always assume new record for now (to avoid ambigious update conflict)
                ['N. N.'].include?( team2_name )
               ## always assume new record for now
               ##   check for date or such - why? why not?
               nil
             elsif round_rec
               ## add match status too? allows [abandoned] and [replay] in same round
               find_attributes = { round_id: round_rec.id,
                                   team1_id: team1_rec.id,
                                   team2_id: team2_rec.id }

               ## add stage if present to query
               find_attributes[ :stage_id] = stage_rec.id   if stage_rec

               Model::Match.find_by( find_attributes )
             else
               ## always assume new record for now
               ##   check for date or such - why? why not?
               nil
             end

       if rec.nil?
        ## find last pos - check if it can be nil?  yes, is nil if no records found
         max_pos = Model::Match.where( event_id: event.id ).maximum( 'pos' )
         max_pos = max_pos ? max_pos+1 : 1

         attribs = { event_id: event.id,          ## todo/fix: change to data struct too?
                     team1_id: team1_rec.id,
                     team2_id: team2_rec.id,
                     pos:      max_pos,
                     num:      match.num,   ## note - might be nil (not nil for euro, world cup, etc.)
                     # date:     match.date.to_date,  ## todo/fix: split and add date & time!!!!
                     date:     match.date,  # assume iso format as string e.g. 2021-07-10 !!!
                     time:     match.time,  # assume iso format as string e.g. 21:00 !!!
                     score1:   match.score1,
                     score2:   match.score2,
                     score1i:  match.score1i,
                     score2i:  match.score2i,
                     score1et: match.score1et,
                     score2et: match.score2et,
                     score1p:  match.score1p,
                     score2p:  match.score2p,
                     status:   match.status }

         attribs[ :round_id ] = round_rec.id   if round_rec
         attribs[ :group_id ] = group_rec.id   if group_rec
         attribs[ :stage_id ] = stage_rec.id   if stage_rec

         rec = Model::Match.create!( attribs )


         #############################################
         ### try to update goals
         ####   quick & dirty v0 - redo !!!!
         goals = match.goals
          if goals && goals.size > 0
            goals.each do |goal|
               person_rec = Model::Person.find_by(
                                           name: goal.player )
               if person_rec.nil?
                 person_rec = Model::Person.create!(
                                key:  goal.player.downcase.gsub( /[^a-z]/, '' ),
                                name: goal.player
                 )
               end
               Model::Goal.create!(
                  match_id:  rec.id,
                  person_id: person_rec.id,
                  team_id:   goal.team == 1 ? rec.team1.id
                                            : rec.team2.id,
                  minute:    goal.minute,
                  offset:    goal.offset || 0,
                  penalty:   goal.penalty,
                  owngoal:   goal.owngoal,
               )
            end
          end
       else
         # update - todo
         puts "!! ERROR - match updates not yet supported (only inserts); sorry"
         exit 1
       end
       rec
    end
  end # class Match

end # module Sync
end # module SportDb
