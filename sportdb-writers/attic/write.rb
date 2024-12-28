
module Writer


class Job     ## todo/check: use a module (and NOT a class) - why? why not?
def self.write( datasets, source:,
                          normalize: false )
  datasets.each_with_index do |dataset,i|
    league  = dataset[0]
    seasons = dataset[1]

    puts "writing [#{i+1}/#{datasets.size}] #{league}..."
    seasons.each_with_index do |season,j|
      puts "  season [#{j+1}/#{season.size}] #{league} #{season}..."
      Writer.write( league: league,
                    season: season,
                    source: source,
                    normalize: normalize )
    end
  end
end
end # class Job




def self.split_matches( matches, season: )
  matches_i  = []
  matches_ii = []
  matches.each do |match|
    date = Date.strptime( match.date, '%Y-%m-%d' )
    if date.year == season.start_year
      matches_i << match
    elsif date.year == season.end_year
      matches_ii << match
    else
      puts "!! ERROR: match date-out-of-range for season:"
      pp season
      pp date
      pp match
      exit 1
    end
  end
  [matches_i, matches_ii]
end



##
##  note: default - do NOT normalize any more

def self.write( league:, season:,
                source:,
                extra: nil,
                split: false,
                normalize: false,
                rounds: true )
  season = Season( season )  ## normalize season

  league_info = LEAGUES[ league ]
  if league_info.nil?
    puts "!! ERROR - no league found for >#{league}<; sorry"
    exit 1
  end

  ## check - if source is directory (assume if starting ./ or ../ or /)
  ## check if directory exists
  ##   todo/fix - use Dir.exist? why? why not?
  unless File.exist?( source )
       puts "!! ERROR: source dir >#{source}< does not exist"
       exit 1
  end
  source_info = { path: source }   ## wrap in "plain" source dir in source info

  source_path = source_info[:path]

  ## format lets you specify directory layout
  ##   default   = 1888-89
  ##   century   = 1800s/1888-89
  ##   ...
  season_path = season.to_path( (source_info[:format] || 'default').to_sym )
  in_path = "#{source_path}/#{season_path}/#{league}.csv"   # e.g. ../stage/one/2020/br.1.csv


  matches = SportDb::CsvMatchParser.read( in_path )
  puts "matches- #{matches.size} records"


  ## check for goals
  in_path_goals = "#{source_path}/#{season_path}/#{league}~goals.csv"   # e.g. ../stage/one/2020/br.1~goals.csv
  if File.exist?( in_path_goals )
    goals = SportDb::CsvGoalParser.read( in_path_goals )
    puts "goals - #{goals.size} records"
    pp goals[0]

    puts
    puts "merge goals:"
    merge_goals( matches, goals )
  end


  pp matches[0]


  if normalize
     if normalize.is_a?(Proc)
        matches = normalize.call( matches, league: league,
                                           season: season )
     else
       puts "!! ERROR - normalize; expected proc got #{normalize.inspect}"
       exit 1
     end
  end



  league_name  = league_info[ :name ]      # e.g. Brasileiro Série A
  basename     = league_info[ :basename]   #.e.g  1-seriea

  league_name =  league_name.call( season )   if league_name.is_a?( Proc )  ## is proc/func - name depends on season
  basename    =  basename.call( season )      if basename.is_a?( Proc )  ## is proc/func - name depends on season

  ## note - repo_path moved!!!
  ## repo_path    = league_info[ :path ]      # e.g. brazil or world/europe/portugal etc.
  repo  = SportDb::GitHubSync::REPOS[ league ]
  repo_path = "#{repo['owner']}/#{repo['name']}"
  repo_path << "/#{repo['path']}"    if repo['path']  ## note: do NOT forget to add optional extra path!!!



  season_path = String.new     ## note: allow extra path for output!!!! e.g. archive/2000s etc.
  season_path << "#{extra}/"   if extra
  season_path << season.path


  ## check for stages
  stages = league_info[ :stages ]
  stages = stages.call( season )    if stages.is_a?( Proc )  ## is proc/func - stages depends on season


  if stages

  ## split into four stages / two files
  ## - Grunddurchgang
  ## - Finaldurchgang - Meister
  ## - Finaldurchgang - Qualifikation
  ## - Europa League Play-off

  matches_by_stage = matches.group_by { |match| match.stage }
  pp matches_by_stage.keys


  ## stages = prepare_stages( stages )
  pp stages


  romans = %w[I II III IIII V VI VII VIII VIIII X XI]  ## note: use "simple" romans without -1 rule e.g. iv or ix

  stages.each_with_index do |stage, i|

    ## assume "extended" style / syntax
    if stage.is_a?( Hash ) && stage.has_key?( :names )
      stage_names    = stage[ :names ]
      stage_basename = stage[ :basename ]
      ## add search/replace {basename} - why? why not?
      stage_basename = stage_basename.sub( '{basename}', basename )
    else  ## assume simple style (array of strings OR hash mapping of string => string)
      stage_names    = stage
      stage_basename =  if stages.size == 1
                            "#{basename}"  ## use basename as is 1:1
                         else
                            "#{basename}-#{romans[i].downcase}"  ## append i,ii,etc.
                         end
    end

    buf = build_stage( matches_by_stage, stages: stage_names,
                                         name: "#{league_name} #{season.key}"
                      )

    ## note: might be empty!!! if no matches skip (do NOT write)
    write_text( "#{config.out_dir}/#{repo_path}/#{season_path}/#{stage_basename}.txt",
                  buf )   unless buf.empty?
  end
  else  ## no stages - assume "regular" plain vanilla season

## always (auto-) sort for now - why? why not?
matches = matches.sort do |l,r|
  ## first by date (older first)
  ## next by matchday (lower first)
  res =   l.date <=> r.date
  res =   l.time <=> r.time     if res == 0 && l.time && r.time
  res =   l.round <=> r.round   if res == 0 && rounds
  res
end

  if split
    matches_i, matches_ii = split_matches( matches, season: season )

    out_path = "#{config.out_dir}/#{repo_path}/#{season_path}/#{basename}-i.txt"

    SportDb::TxtMatchWriter.write( out_path, matches_i,
                                   name: "#{league_name} #{season.key}",
                                   rounds: rounds )

    out_path = "#{config.out_dir}/#{repo_path}/#{season_path}/#{basename}-ii.txt"

    SportDb::TxtMatchWriter.write( out_path, matches_ii,
                                   name: "#{league_name} #{season.key}",
                                   rounds: rounds )
  else
    out_path = "#{config.out_dir}/#{repo_path}/#{season_path}/#{basename}.txt"

    SportDb::TxtMatchWriter.write( out_path, matches,
                                   name: "#{league_name} #{season.key}",
                                   rounds: rounds )
  end
  end
end


=begin
def prepare_stages( stages )
  if stages.is_a?( Array )
     if stages[0].is_a?( Array )  ## is array of array
       ## convert inner array shortcuts to hash - stage input is same as stage output
       stages.map {|ary| ary.reduce({}) {|h,stage| h[stage]=stage; h }}
     elsif stages[0].is_a?( Hash )  ## assume array of hashes
       stages  ## pass through as is ("canonical") format!!!
     else ## assume array of strings
      ## assume single array shortcut; convert to hash - stage input is same as stage output name
      stages = stages.reduce({}) {|h,stage| h[stage]=stage; h }
      [stages]  ## return hash wrapped in array
     end
  else  ## assume (single) hash
    [stages] ## always return array of hashes
  end
end
=end



def self.build_stage( matches_by_stage, stages:, name: )
  buf = String.new

  ## note: allow convenience shortcut - assume stage_in is stage_out - auto-convert
  stages = stages.reduce({}) {|h,stage| h[stage]=stage; h }   if stages.is_a?( Array )

  stages.each_with_index do |(stage_in, stage_out),i|
    matches = matches_by_stage[ stage_in ]   ## todo/fix: report error if no matches found!!!

    next if matches.nil? || matches.empty?

    ## (auto-)sort matches by
    ##  1) date
    matches = matches.sort do |l,r|
      result = l.date  <=> r.date
      result
    end

    buf << "\n\n"   if i > 0 && buf.size > 0

    buf << "= #{name}, #{stage_out}\n"
    buf << SportDb::TxtMatchWriter.build( matches )

    puts buf
  end

  buf
end


end   # module Writer
