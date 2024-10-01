###
#   more to be done - is a dummy for now !!!!!


module Sports
class Team
  ## add convenience lookup helper / method for name by season for now
  ##   use clubs history - for now kept separate from struct - why? why not?
  def name_by_season( season )
        ## note: returns / fallback to "regular" name if no records found in history
        club_history = SportDb::Import.catalog.clubs_history
        club_history.find_name_by( name: name, season: season ) || name
  end
end  # class Team
end  # module Sports

