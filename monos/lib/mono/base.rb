
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

end  ## module Mono


