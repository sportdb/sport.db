
module Mono

  def self.root   ## root of single (monorepo) source tree
    @@root ||= begin
        ## todo/fix:
        ##  check if windows - otherwise use /sites
        ##  check if root directory exists?
        if ENV['MOPATH']
          ENV['MOPATH']
        elsif Dir.exist?( 'C:/Sites' )
          'C:/Sites'
        else
          '/sites'
        end
    end
  end

  def self.monofile
    path =  if File.exist?( './monorepo.yml' )
               './monorepo.yml'
            elsif File.exist?( './monotree.yml' )
               './monotree.yml'
            elsif File.exist?( './repos.yml' )
               './repos.yml'
            else
               puts "!! WARN: no mono configuration file (that is, {monorepo,monotree,repos}.yml) found in >#{Dir.getwd}<"
               nil
            end

    if path
      GitRepoSet.read( path )
    else
      GitRepoSet.new( {} )  ## return empty set -todo/check: return nil - why? why not?
    end
  end

end  ## module Mono


