
module SportDb

  class Deleter
    ######
    # note: make models available in sportdb module by default with namespace
    #  e.g. lets you use Team instead of Model::Team
    include Models

    def run
      # for now delete all tables

      ## stats
      AlltimeStandingEntry.delete_all
      AlltimeStanding.delete_all
      GroupStandingEntry.delete_all
      GroupStanding.delete_all


      Goal.delete_all

      Match.delete_all
      Event.delete_all
      EventTeam.delete_all
      EventGround.delete_all
      Group.delete_all
      GroupTeam.delete_all
      Stage.delete_all
      StageTeam.delete_all
      Round.delete_all
      Badge.delete_all

      Lineup.delete_all

      Team.delete_all

      League.delete_all
      Season.delete_all

      Ground.delete_all   # stadiums

      Assoc.delete_all       # associations / organizations
      AssocAssoc.delete_all  # associations / organizations
    end

  end # class Deleter

end # module SportDb
