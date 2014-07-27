# encoding: utf-8

module SportDb

module Matcher

  include WorldDb::Matcher

  def match_leagues_for_country( name, &blk )
    match_xxx_for_country( name, 'leagues', &blk )
  end

  def match_teams_for_country( name, &blk )
    match_xxx_for_country( name, 'teams', &blk )
  end

  def match_clubs_for_country( name, &blk )
    match_xxx_for_country( name, 'clubs', &blk )
  end

  def match_tracks_for_country( name, &blk )
    match_xxx_for_country( name, 'tracks', &blk )
  end

  def match_skiers_for_country( name, &blk )
    match_xxx_for_country( name, 'skiers', &blk )
  end

  def match_players_for_country( name, &blk )
    match_xxx_for_country( name, 'players', &blk )
  end

  def match_stadiums_for_country( name, &blk )
    match_xxx_for_country( name, 'stadiums', &blk )
  end

end # module Matcher

end # module SportDb
