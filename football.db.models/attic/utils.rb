# encoding: utf-8
# football.db.stats
# utils.rb
#
# This file defines a module of stat parsing helper functions
# for use in parsing stats for any entity (player, game, event)

module SportDb
  module StatParseHelpers

  # Parse out stats format
  # $$ statKey: value, statKey: value
  # Assumes stats apply to a person or a game
  # Create a stats object if one does not exist for this
  # person/game.  Update the corresponding statistic
  #
  # Returns true if this line is a stats line
  def parse_stats (line, event, person=nil, team = nil, game=nil)

    # For simplicity, have stat lines start with $$
    if (not (line =~ /^\$\$/))
      return false
    end

    if (person == nil and game == nil)
      logger.error " !!!!!! No person or game to match stats with line: #{line}"
      # Return true to skip the line
      return true
    end

    # Parse out components
    line.sub!("$$","").strip!
    stats_l = line.split(",")

    logger.debug "   stats_l: #{stats_l}"

    stats_l.each do |stat_s|
      logger.debug "   stat_s: #{stat_s}"
      components_l = stat_s.split(":")
      if (components_l[1] == nil)
        logger.error " !!!!!! Malformed stats line: #{stat_s}"
        next
      end

      parse_player_stat(components_l[0].strip, components_l[1].strip, event.id, person.id, team.id)

    end # each stat

    return true
  end

  # Try to match 'key' with a field in the player_stats table
  # return nil on failure
  def map_player_stat_field(key)
    case key
      # Identity mapping
      when "starts", "subIns", "saves", "goalsConceded", "foulsCommitted", "foulsSuffered", "yellowCards", "redCards", "wins", "losses", "draws", "totalGoals", "totalShots", "shotsOnTarget", "goalAssists", "minutesPlayed", "position"
        return key
      # Any aliases...
      when "pos"
        return "position"
    #default
    else
      return nil
    end
  end

  # Handle stat parsing for players
  #   game, person not nil => A player's performance in a game... team implied?
  #   team, person, event not nil => A player's performance in a season on one team
  #   person, event not nil => A player's performance in a season across all teams
  #   person not nil => A player's all-time performance across all teams
  def parse_player_stat(stat_key, stat_value, event_id=nil, person_id=nil, team_id=nil, game_id=nil)
    # Try to map this to a stat_field
    stat_field = map_player_stat_field(stat_key)

    if(stat_field)
      # Look for an existing player_stat item
      player_stat = Model::PlayerStat.find_by_event_id_and_person_id_and_team_id_and_game_id(event_id, person_id, team_id, game_id)

      if (player_stat == nil)
        player_stat = Model::PlayerStat.create(event_id: event_id, person_id: person_id, team_id: team_id, game_id: game_id)
      end

      player_stat[stat_field] = stat_value

      # Report any errors
      if(not player_stat.save)
        player_stat.errors.messages.each {|m| logger.error(m)}
      end
      
      logger.debug "  updated player_data: #{player_stat.inspect}"
    # Create a generic stat if a field is not available
    else
      stat = find_or_create_stat(stat_key, stat_value)
      logger.debug "   Using stat: #{stat.title}"

      # Find or create stat_data
      stat_data = nil
      stat_data_attr = {
        value: stat_value,
        event_id: event_id,
        stat_id: stat.id,
        team_id: team_id
      }

      # Person guaranteed to be non-nil here
      stat_data_attr[:person_id] = person_id
      stat_data = Model::StatData.find_by_event_id_and_person_id_and_stat_id_and_team_id(event_id, person_id, stat.id, team.id)

      # Create or update stat
      if (stat_data == nil)
        logger.debug "   No stat data found for #{stat.key}, creating a new one"
        stat_data = Model::StatData.create(stat_data_attr)
      else
        logger.debug "   Using existing stat data: #{stat_data.inspect}"
        stat_data = Model::StatData.update_attributes!(stat_data_attr)
      end

      logger.debug "   Saved stat_data: #{stat_data.inspect}"
    end # if !stat_field

  end

  # Try to find an existing generic stat.  If none exists,
  # create a new one.  Return the stat that was found or created
  def find_or_create_stat(stat_key, stat_value)
    # Find or create a stat
    stat = Model::Stat.find_by_key(stat_key)
    if (stat == nil)
      stat = Model::Stat.create(key: stat_key, title: stat_key)
    end
    
    return stat
  end

  end # module 
end # module SportDb
