
module SportDb

  class Deleter
    ######
    # NB: make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Models::Team 
    include SportDb::Models

    def run
      # for now delete all tables
      
      Team.delete_all
      Game.delete_all
      Event.delete_all
      EventTeam.delete_all
      Group.delete_all
      GroupTeam.delete_all
      Round.delete_all
      Badge.delete_all
      League.delete_all
      Season.delete_all
    end
    
  end # class Deleter
  
end # module SportDb