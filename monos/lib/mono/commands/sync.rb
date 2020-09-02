module Mono

  ## pass along hash of repos (e.g. monorepo.yml or repos.yml )
  def self.sync( h=Mono.monofile )
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
      FileUtils.mkdir_p( org_path ) unless Dir.exist?( org_path )   ## make sure path exists

      names.each do |name|
          puts "[#{count_repos+1}/#{total_repos}] #{org}@#{name}..."

          repo = GitHubRepo.new( org, name )  ## owner, name e.g. rubylibs/webservice

          Dir.chdir( org_path ) do
            if Dir.exist?( repo.name )
              GitRepo.open( repo.name ) do |git|
                if git.changes?
                  puts "!! WARN - local changes in workdir; skipping fast forward (remote) sync / merge"
                else
                  git.fast_forward   ## note: use git pull --ff-only (fast forward only - do NOT merge)
                end
              end
            else
              Git.clone( repo.ssh_clone_url )
            end
          end

#
# todo/fix: add (back) error log !!!!!!!!!!!!
#        rescue GitError => ex
#          puts "!! ERROR: #{ex.message}"
#
#          File.open( './errors.log', 'a' ) do |f|
#              f.write "#{Time.now} -- repo #{org}/#{name} - #{ex.message}\n"
#           end

          count_repos += 1
      end
      count_orgs += 1
    end

    ## print stats
    puts "#{count_repos} repo(s) @ #{count_orgs} org(s)"
  end # method sync

end  # module Mono
