
class GitError < StandardError
end

class Git   ## make Git a module - why? why not?

  ###
  ## todo/fix:  change opts=nil to *args or such - why? why not?


  ###############
  ## "setup" starter git commands

  def self.clone( repo, name=nil )
    cmd = "git clone #{repo}"
    cmd << " #{name}"   unless name.nil? || name.empty?
    Shell.run( cmd )
  end

  def self.mirror( repo )
    cmd = "git clone --mirror #{repo}"
    Shell.run( cmd )
  end


  #################
  ## standard git commands

  def self.version
    cmd = 'git --version'
    Shell.run( cmd )
  end

  def self.status( short: false )
    cmd = 'git status'
    cmd << " --short"   if short
    Shell.run( cmd )
  end

  def self.changes  ## same as git status --short  - keep shortcut / alias - why? why not?
    ## returns changed files - one per line or empty if no changes
    cmd = 'git status --short'
    Shell.run( cmd )
  end

  #####################
  ## status helpers

  ## git status --short  returns empty stdout/list
  def self.clean?()   changes.empty?; end

  def self.changes?() clean? == false; end  ## reverse of clean?
  class << self
    alias_method :dirty?, :changes?  ## add alias
  end


  #######
  ## more (major) git commands

  def self.pull
    cmd = 'git pull'
    Shell.run( cmd )
  end

  def self.fast_forward
    cmd = 'git pull --ff-only'
    Shell.run( cmd )
  end
  class << self
    alias_method :ff, :fast_forward   ## add alias
  end


  def self.push
    cmd = 'git push'
    Shell.run( cmd )
  end

  def self.add( pathspec=nil )  ## e.g. git add .  or git add *.rb or such
    cmd = 'git add'
    cmd << " #{pathspec}"   unless pathspec.nil? || pathspec.empty?
    Shell.run( cmd )
  end

  def self.add_all
    cmd = 'git add --all'
    Shell.run( cmd )
  end

  def self.commit( message: )
    cmd = 'git commit'
    cmd << %Q{ -m "#{message}"}  unless message.nil? || message.empty?
    Shell.run( cmd )
  end


###
#  use nested class for "base" for running commands - why? why not?
class Shell
def self.run( cmd )
  print "cmd exec >#{cmd}<..."
  stdout, stderr, status = Open3.capture3( cmd )

  if status.success?
    print " OK"
    print "\n"
  else
    print " FAIL (#{status.exitstatus})"
    print "\n"
  end

  unless stdout.empty?
    puts stdout
  end

  unless stderr.empty?
    ## todo/check: or use >2: or &2: or such
    ##  stderr output not always an error (that is, exit status might be 0)
    puts "STDERR:"
    puts stderr
  end

  if status.success?
    stdout   # return stdout string
  else
    puts "!! ERROR: cmd exec >#{cmd}< failed with exit status #{status.exitstatus}:"
    puts stderr
    raise GitError, "git cmd exec >#{cmd}< failed with exit status #{status.exitstatus}<: #{stderr}"
  end
end
end # class Shell

end # class Git



class GitRepo
  def self.open( path, &blk )
    new( path ).open( &blk )
  end

  def initialize( path )
    raise ArgumentError, "dir >#{path}< not found; dir MUST already exist for GitRepo class - sorry"   unless Dir.exist?( path )
    @path = path
  end

  def open( &blk )
    ## puts "Dir.getwd: #{Dir.getwd}"
    Dir.chdir( @path ) do
      blk.call( self )
    end
    ## puts "Dir.getwd: #{Dir.getwd}"
  end


  def status( short: false )    Git.status( short: short ); end
  def changes()                 Git.changes; end
  def clean?()                  Git.clean?; end
  def changes?()                Git.changes?; end
  alias_method :dirty?, :changes?

  def pull()                    Git.pull; end
  def fast_forward()            Git.fast_forward; end
  alias_method :ff, :fast_forward

  def push()                    Git.push; end

  def add( pathspec )           Git.add( pathspec ); end
  def add_all()                 Git.add_all; end
  def commit( message: )        Git.commit( message: message ); end


end # class GitRepo
