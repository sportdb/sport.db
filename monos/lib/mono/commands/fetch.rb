module Mono

  ## pass along hash of repos (e.g. monorepo.yml or repos.yml )
  def self.fetch
    repos = Mono.monofile

    count_orgs  = 0
    count_repos = 0

    total_repos = repos.size


    repos.each do |org,names|

      org_path = "#{Mono.root}/#{org}"

      names.each do |name|
          puts "[#{count_repos+1}/#{total_repos}] #{org}@#{name}..."

          repo = GitHubRepo.new( org, name )  ## owner, name e.g. rubylibs/webservice

          Dir.chdir( org_path ) do
            if Dir.exist?( repo.name )
              GitProject.open( repo.name ) do |proj|
                proj.fetch
              end
            else
              puts "!!  repo not found / missing"
            end
          end

          count_repos += 1
      end
      count_orgs += 1
    end


    ## print stats & changes summary
    puts
    print "#{count_repos} repo(s) @ #{count_orgs} org(s)"
    print "\n"
  end # method fetch

end  # module Mono
