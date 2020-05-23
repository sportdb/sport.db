
  def add_teams_from_ary!( team_keys )
    ## move to depreciated? used in event reader? why? why not?
    team_keys.each do |team_key|
      team = Team.find_by_key!( team_key )
      self.teams << team
    end
  end

    #####################
  ## convenience helper for text parser/reader

  ###
  ## fix: use/add  to_teams_table( rec )  for reuse
  #
  ##  @known_teams = @event.known_teams_table


  def known_teams_table
    @known_teams_table ||= TextUtils.build_title_table_for( teams )
  end # method known_teams_table
