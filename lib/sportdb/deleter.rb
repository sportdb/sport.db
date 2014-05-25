
module SportDb

  class Deleter
    ######
    # NB: make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Model::Team
    include SportDb::Models

    def run
      # for now delete all tables
      
      ## stats
      AlltimeStandingEntry.delete_all
      AlltimeStanding.delete_all
      GroupStandingEntry.delete_all
      GroupStanding.delete_all


      Goal.delete_all
      Record.delete_all

      Game.delete_all
      Event.delete_all
      EventTeam.delete_all
      EventGround.delete_all
      Group.delete_all
      GroupTeam.delete_all
      Round.delete_all
      Badge.delete_all

      Run.delete_all
      Race.delete_all
      Roster.delete_all

      Track.delete_all
      Team.delete_all
      
      League.delete_all
      Season.delete_all
      
      Ground.delete_all   # stadiums
    end
    
  end # class Deleter
  
end # module SportDb