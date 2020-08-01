# encoding: utf-8

module SportDb

class Opts

  def merge_gli_options!( options = {} )
    @db_path   = options[:dbpath]    if options[:dbpath].present?
    @db_name   = options[:dbname]    if options[:dbname].present?
    @datafile  = options[:datafile]  if options[:datafile].present?

    @verbose = true     if options[:verbose] == true

    @leagues_dir = options[:'leagues-dir']   if options[:'leagues-dir'].present?
    @clubs_dir   = options[:'clubs-dir']     if options[:'clubs-dir'].present?
  end


  def verbose=(boolean)   # add: alias for debug ??
    @verbose = boolean
  end

  def verbose?
    return false if @verbose.nil?   # default verbose/debug flag is false
    @verbose == true
  end


  def db_path()   @db_path || '.';         end
  def db_name()   @db_name || 'sport.db';  end

  def datafile()  @datafile || './Datafile';  end
  def datafile?() @datafile;  end    ## note: let's you check if datafile is set (or "untouched")


  def clubs_dir()    @clubs_dir;  end
  def clubs_dir?()   @clubs_dir.nil? == false;  end ## note: let's you check if clubs_dir set (by default it's NOT set)

  def leagues_dir()  @leagues_dir;  end
  def leagues_dir?() @leagues_dir.nil? == false; end
end # class Opts

end # module SportDb
