
module Sports


class TeamUsage

  class TeamUsageLine   ## nested class
    attr_accessor  :team,
                   :matches,  ## number of matches (played),
                   :seasons,  ## (optianl) array of seasons, use seasons.size for count
                   :levels    ## (optional) hash of levels (holds mapping level to TeamUsageLine)

    def initialize( team )
      @team = team

      @matches  = 0
      @seasons  = []
      @levels   = {}
    end
  end # (nested) class TeamUsageLine



  def initialize( opts={} )
    @lines = {}   # StandingsLines cached by team name/key
  end


  def update( matches, season: '?', level: nil )
    ## convenience - update all matches at once
    matches.each_with_index do |match,i| # note: index(i) starts w/ zero (0)
      update_match( match, season: season, level: level )
    end
    self  # note: return self to allow chaining
  end

  def to_a
    ## return lines; sort

    # build array from hash
    ary = []
    @lines.each do |k,v|
      ary << v
    end

    ## for now sort just by name (a-z)
    ary.sort! do |l,r|
      ## note: reverse order (thus, change l,r to r,l)
      l.team <=> r.team
    end

    ary
  end  # to_a


private
  def update_match( m, season: '?', level: nil )   ## add a match

    line1 = @lines[ m.team1 ] ||= TeamUsageLine.new( m.team1 )
    line2 = @lines[ m.team2 ] ||= TeamUsageLine.new( m.team2 )

    line1.matches +=1
    line2.matches +=1

    ## include season if not seen before (allow season in multiple files!!!)
    line1.seasons << season    unless line1.seasons.include?( season )
    line2.seasons << season    unless line2.seasons.include?( season )

    if level
      line1_level = line1.levels[ level ] ||= TeamUsageLine.new( m.team1 )
      line2_level = line2.levels[ level ] ||= TeamUsageLine.new( m.team2 )

      line1_level.matches +=1
      line2_level.matches +=1

      line1_level.seasons << season    unless line1_level.seasons.include?( season )
      line2_level.seasons << season    unless line2_level.seasons.include?( season )
    end
  end  # method update_match


end # class TeamUsage

end # module Sports
