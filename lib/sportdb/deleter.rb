
module SportDB

  class Deleter
    ## todo: move into its own file???    
    
    ## make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Models::Team 
    include SportDB::Models

    def run( args=[] )
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
  
end # module SportDB