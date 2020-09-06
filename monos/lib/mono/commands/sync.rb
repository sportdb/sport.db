module Mono

  ## pass along hash of repos (e.g. monorepo.yml or repos.yml )
  def self.sync
    repos = Mono.monofile

    count_orgs  = 0
    count_repos = 0

    total_repos = repos.size

    repos.each do |org,names|
      org_path = "#{Mono.root}/#{org}"
      FileUtils.mkdir_p( org_path ) unless Dir.exist?( org_path )   ## make sure path exists

      names.each do |name|
          puts "[#{count_repos+1}/#{total_repos}] #{org}@#{name}..."

          repo = GitHubRepo.new( org, name )  ## owner, name e.g. rubylibs/webservice

          Dir.chdir( org_path ) do
            if Dir.exist?( repo.name )
              GitProject.open( repo.name ) do |proj|
                if proj.changes?
                  puts "!! WARN - local changes in workdir; skipping fast forward (remote) sync / merge"
                else
                  proj.fast_forward   ## note: use git pull --ff-only (fast forward only - do NOT merge)
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
