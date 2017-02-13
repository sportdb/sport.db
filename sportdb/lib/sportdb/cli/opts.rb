# encoding: utf-8

module SportDb

class Opts

  def merge_gli_options!( options = {} )
    @db_path   = options[:dbpath]  if options[:dbpath].present?
    @db_name   = options[:dbname]  if options[:dbname].present?

    @verbose = true     if options[:verbose] == true

    @data_path       = options[:include]      if options[:include].present?
    @world_data_path = options[:worldinclude] if options[:worldinclude].present? 
  end


  def verbose=(boolean)   # add: alias for debug ??
    @verbose = boolean
  end

  def verbose?
    return false if @verbose.nil?   # default verbose/debug flag is false
    @verbose == true
  end


  def db_path
    @db_path || '.'
  end

  def db_name
    @db_name || 'sport.db'
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

end # module SportDb
