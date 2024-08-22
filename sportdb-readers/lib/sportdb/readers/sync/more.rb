
module SportDb
  module Sync


  class NationalTeam
    def self.find_or_create( team )
      rec = Model::Team.find_by( name: team.name )
      if rec.nil?
        puts "add national team: #{team.key}, #{team.name}, #{team.country.name} (#{team.country.key})"

        ### note: key expected three or more lowercase letters a-z /\A[a-z]{3,}\z/
        attribs = {
          key:        team.key,   ## note: always use downcase fifa code for now!!!
          name:       team.name,
          code:       team.code,
          country_id: Sync::Country.find_or_create( team.country ).id,
          club:       false,
          national:   true  ## check -is default anyway - use - why? why not?
        }

        if team.alt_names.empty? == false
          attribs[:alt_names] = team.alt_names.join('|')
        end

        rec = Model::Team.create!( attribs )
      end
      rec
    end
  end # class NationalTeam


  class Team
    ## auto-cache all clubs by find_or_create for later mapping / lookup
    def self.cache() @cache ||= {}; end

    def self.find_or_create( team_or_teams )
      if team_or_teams.is_a?( Array )
        recs = []
        teams = team_or_teams
        teams.each do |team|
          recs << __find_or_create( team )
        end
        recs
      else  # assome single rec
        team = team_or_teams
        __find_or_create( team )
      end
    end

    def self.__find_or_create( team )  ## todo/check: use find_or_create_worker instead of _find - why? why not?
       rec = if team.is_a?( Import::NationalTeam )
               NationalTeam.find_or_create( team )
             else ## assume Club
               Club.find_or_create( team )
             end
       cache[ team.name ] = rec    ## note: assume "canonical" unique team name
       rec
    end
  end # class Team



  class Round
    def self.find_or_create( round, event: )
       rec = Model::Round.find_by( name: round.name, event_id: event.id )
       if rec.nil?
         ## find last pos - check if it can be nil?
         max_pos = Model::Round.where( event_id: event.id ).maximum( 'pos' )
         max_pos = max_pos ? max_pos+1 : 1

         attribs = { event_id: event.id,
                     name:     round.name,
                     pos:      max_pos
                   }

         ## todo/fix:  check if round has (optional) start or end date and add!!!
         ## attribs[ :start_date] = round.start_date.to_date

         rec = Model::Round.create!( attribs )
       end
       rec
    end
  end # class Round


  class Group
    def self.find_or_create( group, event: )
       rec = Model::Group.find_by( name: group.name, event_id: event.id )
       if rec.nil?
         ## find last pos - check if it can be nil?
         max_pos = Model::Group.where( event_id: event.id ).maximum( 'pos' )
         max_pos = max_pos ? max_pos+1 : 1

         attribs = { event_id: event.id,
                     name:     group.name,
                     pos:      max_pos
                   }

         ## todo/fix: check/add optional group key (was: pos before)!!!!
         rec = Model::Group.create!( attribs )
       end
       ## todo/fix: add/update teams in group too!!!!!
       rec
    end
  end # class Group


  class Stage
    def self.find( name, event: )
      Model::Stage.find_by( name: name, event_id: event.id  )
    end
    def self.find!( name, event: )
      rec = find( name, event: event  )
      if rec.nil?
        puts "** !!!ERROR!!! db sync - no stage match found for:"
        pp name
        pp event
        exit 1
      end
      rec
    end

    def self.find_or_create( name, event: )
       rec = find( name, event: event )
       if rec.nil?
         attribs = { event_id: event.id,
                     name:     name,
                   }
         rec = Model::Stage.create!( attribs )
       end
       rec
    end
  end # class Stage
end # module Sync
end # module SportDb
