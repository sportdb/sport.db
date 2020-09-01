

module Mono

  ## pass along hash of repos (e.g. monorepo.yml or repos.yml )
  def self.status( h=Mono.monofile )
    changes =  []   ## track changes

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
              GitRepo.open( repo.name ) do |git|
                output = git.changes
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
