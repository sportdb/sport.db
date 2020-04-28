# encoding: utf-8


module SportDb

module Sync
  class Country
    def self.find_or_create( country )
       rec = WorldDb::Model::Country.find_by( key: country.key )
       if rec.nil?
         attribs = {
           key:  country.key,
           name: country.name,
           code: country.fifa,  ## fix:  uses fifa code now (should be iso-alpha3 if available)
           fifa: country.fifa,
           area: 1,
           pop:  1
         }
         rec = WorldDb::Model::Country.create!( attribs )
       end
       rec
    end
  end # class Country


  class League
    def self.find( league )
      Model::League.find_by( key: league.key )
    end
    def self.find!( league )
      rec = find( league )
      if rec.nil?
        puts "** !!!ERROR!!! db sync - no league match found for:"
        pp league
        exit 1
      end
      rec
    end

    def self.find_or_create( league )
       rec = find( league )
       if rec.nil?
         ## use title and not name - why? why not?
         ##  quick fix:  change name to title
         attribs = { key:   league.key,
                     title: league.name }
         if league.country
           attribs[ :country_id ] = Sync::Country.find_or_create( league.country ).id
         end

         rec = Model::League.create!( attribs )
       end
       rec
    end
  end # class League


  class Season
    def self.normalize_key( key )    ## helper for season key (rename to norm_key ???)
      ## note:  "normalize" season key
      ##   always use 2017/18  (and not 2017-18 or 2017-2018 or 2017/2018)
      ## 1) change 2017-18 to 2017/18
      key = key.tr( '-', '/' )
      ## 2) check for 2017/2018 - change to 2017/18
      if key.length == 9
        key = "#{key[0..3]}/#{key[7..8]}"
      end
      key
    end

    def self.find( key )
      key = normalize_key( key )
      Model::Season.find_by( key: key )
    end
    def self.find!( key )
      rec = find( key )
      if rec.nil?
        puts "** !!!ERROR!!! db sync - no season match found for >#{normalize_key(key)}<:"
        pp key
        exit 1
      end
      rec
    end

    def self.find_or_create( key )  ## e.g. key = '2017/18'
      rec = find( key )
      if rec.nil?
         key = normalize_key( key )  ## note: do NOT forget to normalize key e.g. always use slash (2019/20) etc.
         attribs = { key:   key,
                     title: key  }
         rec = Model::Season.create!( attribs )
      end
      rec
    end
  end # class Season

  class Club
    def self.find_or_create( club )
      rec = Model::Team.find_by( title: club.name )
      if rec.nil?
        ## check if key is present otherwise generate e.g. remove all non-ascii a-z chars
        key  =  club.key || club.name.downcase.gsub( /[^a-z]/, '' )
        puts "add club: #{key}, #{club.name}, #{club.country.name} (#{club.country.key})"

        attribs = {
          key:        key,
          title:      club.name,
          country_id: Sync::Country.find_or_create( club.country ).id,
          club:       true,
          national:   false  ## check -is default anyway - use - why? why not?
          ## todo/fix: add city if present - why? why not?
        }

        attribs[:code] = club.code   if club.code   ## add code (abbreviation) if present


        if club.alt_names.empty? == false
          attribs[:synonyms] = club.alt_names.join('|')
        end

        rec = Model::Team.create!( attribs )
      end
      rec
    end
  end # class Club



  class NationalTeam
    def self.find_or_create( team )
      rec = Model::Team.find_by( title: team.name )
      if rec.nil?
        puts "add national team: #{team.key}, #{team.name}, #{team.country.name} (#{team.country.key})"

        ### fix: change back key to team.key!!!!
        ## ActiveRecord::RecordInvalid: Validation failed:
        #    Key expected three or more lowercase letters a-z /\A[a-z]{3,}\z/
        attribs = {
          key:        team.code.downcase,
          title:      team.name,
          code:       team.code,
          country_id: Sync::Country.find_or_create( team.country ).id,
          club:       false,
          national:   true  ## check -is default anyway - use - why? why not?
        }

        if team.alt_names.empty? == false
          attribs[:synonyms] = team.alt_names.join('|')
        end

        rec = Model::Team.create!( attribs )
      end
      rec
    end
  end # class NationalTeam


  class Event
    def self.find( league:, season: )
      Model::Event.find_by( league_id: league.id, season_id: season.id  )
    end
    def self.find!( league:, season: )
      rec = find( league: league, season: season )
      if rec.nil?
        puts "** !!!ERROR!!! db sync - no event match found for:"
        pp league
        pp season
        exit 1
      end
      rec
    end

    def self.find_or_create( league:, season: )
      rec = find( league: league, season: season )
      if rec.nil?
        ## quick hack/change later !!
        ##  todo/fix: check season  - if is length 4 (single year) use 2017, 1, 1
        ##                               otherwise use 2017, 7, 1
        ##  start_at use year and 7,1 e.g. Date.new( 2017, 7, 1 )
        ## hack:  fix/todo1!!
        ##   add "fake" start_at date for now
        if season.key.size == '4'   ## e.g. assume 2018 etc.
          year = season.key.to_i
          start_at = Date.new( year, 1, 1 )
        else  ## assume 2014/15 etc.
          year = season.key[0..3].to_i
          start_at = Date.new( year, 7, 1 )
        end

        attribs = {
          league_id: league.id,
          season_id: season.id,
          start_at:  start_at  }

        rec = Model::Event.create!( attribs )
      end
      rec
    end
  end  # class Event

  class Round
    def self.find_or_create( round, event: )
       rec = Model::Round.find_by( title: round.title, event_id: event.id )
       if rec.nil?
         attribs = { event_id: event.id,
                     title:    round.title,
                     pos:      round.pos,
                     start_at: event.start_at.to_date
                   }
         rec = Model::Round.create!( attribs )
       end
       rec
    end
  end # class Round


  class Group
    def self.find_or_create( group, event: )
       rec = Model::Group.find_by( title: group.title, event_id: event.id )
       if rec.nil?
         attribs = { event_id: event.id,
                     title:    group.title,
                     pos:      group.pos
                   }
         rec = Model::Group.create!( attribs )
       end
       ## todo/fix: add/update teams in group too!!!!!
       rec
    end
  end # class Group


  class Stage
    def self.find( name, event: )
      Model::Stage.find_by( title: name, event_id: event.id  )
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
         ## use title and not name - why? why not?
         ##  quick fix:  change name to title
         attribs = { event_id: event.id,
                     title:    name,
                   }
         rec = Model::Stage.create!( attribs )
       end
       rec
    end
  end # class Stage



  class Match   ## todo/check:  add alias for Game class - why? why not?
    def self.create_or_update( match, event: )
       ## note: MUST find round, thus, use bang (!)

       ## todo/check: allow strings too - why? why not?

       ## query for round - allow string or round rec
       round_title = match.round.is_a?( String ) ? match.round : match.round.title
       round_rec   = Model::Round.find_by!( event_id: event.id,
                                            title:    round_title )


       team1_rec =  if match.team1.is_a?( String )
                      Model::Team.find_by!( title: match.team1  )
                    else
                      match.team1  ### note: assumes ActiveRecord team record with id!!
                    end
       team2_rec =  if match.team2.is_a?( String )
                      Model::Team.find_by!( title: match.team2 )
                    else
                      match.team2  ### note: assumes ActiveRecord team record with id!!
                    end


       ## check optional group (e.g. Group A, etc.)
       group_rec = if match.group
                     group_title = match.group.is_a?( String ) ? match.group : match.group.title
                     Model::Group.find_by!( event_id: event.id,
                                            title:    group_title )
                   else
                     nil
                   end


       rec = Model::Game.find_by( round_id: round_rec.id,
                                  team1_id: team1_rec.id,
                                  team2_id: team2_rec.id )
       if rec.nil?
         attribs = { round_id: round_rec.id,
                     team1_id: team1_rec.id,
                     team2_id: team2_rec.id,
                     pos:      999,    ## make optional why? why not? - change to num?
                     play_at:  match.date.to_date,
                     score1:   match.score1,
                     score2:   match.score2,
                     score1i:  match.score1i,
                     score2i:  match.score2i }
         attribs[ :group_id ] = group_rec.id   if group_rec

         rec = Model::Game.create!( attribs )
       else
         # update - todo
       end
       rec
    end
  end # class Match

end # module Sync
end # module SportDb
