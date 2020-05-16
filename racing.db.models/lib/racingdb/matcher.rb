# encoding: utf-8

module SportDb

## note:
##  extends "default" matcher module in sportdb/matcher.rb

module Matcher

  def match_skiers_for_country( name, &blk )
    match_xxx_for_country( name, 'skiers', &blk )
  end

  def match_tracks_for_country( name, &blk )
    match_xxx_for_country( name, 'tracks', &blk )
  end

end # module Matcher

end # module SportDb

