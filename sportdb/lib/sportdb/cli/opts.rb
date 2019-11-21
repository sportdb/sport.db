# encoding: utf-8

module SportDb

class Opts

  def merge_gli_options!( options = {} )
    @db_path   = options[:dbpath]  if options[:dbpath].present?
    @db_name   = options[:dbname]  if options[:dbname].present?

    @verbose = true     if options[:verbose] == true
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
end # class Opts

end # module SportDb
