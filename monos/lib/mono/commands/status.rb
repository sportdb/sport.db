module Mono

  ## pass along hash of repos (e.g. monorepo.yml or repos.yml )
  def self.status
    repos = Mono.monofile

    changes =  []   ## track changes

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
                output = proj.changes
                if output.empty?
                   puts "   - no changes -"
                else
                  changes << ["#{org}@#{name}", :CHANGES, output]
                end
              end
            else
              puts "!!  repo not found / missing"
              changes << ["#{org}@#{name}", :NOT_FOUND]
            end
          end

          count_repos += 1
      end
      count_orgs += 1
    end


    ## print stats & changes summary
    puts
    print "#{changes.size} change(s) in "
    print "#{count_repos} repo(s) @ #{count_orgs} org(s)"
    print "\n"

    changes.each do |item|
      puts
      print "== #{item[0]} - #{item[1]}"
      case item[1]
      when :CHANGES
        print ":\n"
        print item[2]
      when :NOT_FOUND
        print "\n"
      end
    end

  end # method status

end  # module Mono
