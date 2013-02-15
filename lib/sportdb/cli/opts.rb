module SportDB

class Opts

  def merge_commander_options!( options = {} )
    @data_path = options[:include] if options[:include].present?
    @event     = options[:event]   if options[:event].present?
    
    @world_data_path = options[:worldinclude] if options[:worldinclude].present? 
  end


  def event=(value)
    @event = value
  end

  def event
    @event   # NB: option has no default; return nil  ## || '.'
  end


  def data_path=(value)
    @data_path = value
  end

  def data_path
    @data_path || '.'
  end


  def world_data_path
    @world_data_path   # NB: option has no default; return nil
  end

end # class Opts

end # module SportDB
