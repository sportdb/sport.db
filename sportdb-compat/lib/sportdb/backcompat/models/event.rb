# encoding: utf-8

module SportDb
  module Model

#############################################################
# collect depreciated or methods for future removal here
# - keep for now for compatibility (for old code)

class Event

  def full_title   # includes season (e.g. year)
    puts "*** depreciated API call Event#full_title; use Event#title instead; full_title will get removed"
    "#{league.title} #{season.title}"    
  end

end # class Event


  end # module Model
end # module SportDb

