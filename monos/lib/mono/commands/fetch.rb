module Mono

  ## pass along hash of repos (e.g. monorepo.yml or repos.yml )
  def self.fetch( h=Mono.monofile )
    count_orgs  = 0
    count_repos = 0

    ## sum up total number of repos
    total_repos = h.reduce(0) {|sum,(_,names)| sum+= names.size; sum }


    h.each do |org_with_counter,names|

      ## remove optional number from key e.g.
      ##   mrhydescripts (3)    =>  mrhydescripts
      ##   footballjs (4)       =>  footballjs
      ##   etc.
      org = org_with_counter.sub( /\([0-9]+\)/, '' ).strip

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
