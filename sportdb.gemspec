# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sportdb"
  s.version = "1.8.28"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gerald Bauer"]
  s.date = "2014-05-31"
  s.description = "sportdb - sport.db command line tool"
  s.email = "opensport@googlegroups.com"
  s.executables = ["sportdb"]
  s.extra_rdoc_files = ["HISTORY.md", "Manifest.txt", "README.md"]
  s.files = ["HISTORY.md", "Manifest.txt", "README.md", "Rakefile", "bin/sportdb", "config/fixtures/de.yml", "config/fixtures/en.yml", "config/fixtures/es.yml", "config/fixtures/fr.yml", "config/fixtures/it.yml", "config/fixtures/pt.yml", "config/fixtures/ro.yml", "data/seasons.txt", "data/setups/all.txt", "lib/sportdb.rb", "lib/sportdb/calc.rb", "lib/sportdb/cli/main.rb", "lib/sportdb/cli/opts.rb", "lib/sportdb/console.rb", "lib/sportdb/data/keys.rb", "lib/sportdb/data/models.rb", "lib/sportdb/deleter.rb", "lib/sportdb/finders/date.rb", "lib/sportdb/finders/scores.rb", "lib/sportdb/lang.rb", "lib/sportdb/matcher.rb", "lib/sportdb/models/badge.rb", "lib/sportdb/models/event.rb", "lib/sportdb/models/event_ground.rb", "lib/sportdb/models/event_team.rb", "lib/sportdb/models/forward.rb", "lib/sportdb/models/game.rb", "lib/sportdb/models/goal.rb", "lib/sportdb/models/ground.rb", "lib/sportdb/models/group.rb", "lib/sportdb/models/group_team.rb", "lib/sportdb/models/league.rb", "lib/sportdb/models/person.rb", "lib/sportdb/models/race.rb", "lib/sportdb/models/record.rb", "lib/sportdb/models/roster.rb", "lib/sportdb/models/round.rb", "lib/sportdb/models/run.rb", "lib/sportdb/models/season.rb", "lib/sportdb/models/stats/alltime_standing.rb", "lib/sportdb/models/stats/alltime_standing_entry.rb", "lib/sportdb/models/stats/event_standing.rb", "lib/sportdb/models/stats/event_standing_entry.rb", "lib/sportdb/models/stats/group_standing.rb", "lib/sportdb/models/stats/group_standing_entry.rb", "lib/sportdb/models/team.rb", "lib/sportdb/models/track.rb", "lib/sportdb/models/utils.rb", "lib/sportdb/models/world/city.rb", "lib/sportdb/models/world/continent.rb", "lib/sportdb/models/world/country.rb", "lib/sportdb/models/world/region.rb", "lib/sportdb/patterns.rb", "lib/sportdb/reader.rb", "lib/sportdb/readers/event.rb", "lib/sportdb/readers/game.rb", "lib/sportdb/readers/ground.rb", "lib/sportdb/readers/league.rb", "lib/sportdb/readers/national_team.rb", "lib/sportdb/readers/race.rb", "lib/sportdb/readers/race_team.rb", "lib/sportdb/readers/record.rb", "lib/sportdb/readers/season.rb", "lib/sportdb/readers/team.rb", "lib/sportdb/readers/track.rb", "lib/sportdb/schema.rb", "lib/sportdb/service.rb", "lib/sportdb/service/public/style.css", "lib/sportdb/service/public/style.css.scss", "lib/sportdb/service/server.rb", "lib/sportdb/service/views/_debug.erb", "lib/sportdb/service/views/_version.erb", "lib/sportdb/service/views/debug.erb", "lib/sportdb/service/views/index.erb", "lib/sportdb/service/views/layout.erb", "lib/sportdb/stats.rb", "lib/sportdb/updater.rb", "lib/sportdb/utils.rb", "lib/sportdb/utils_date.rb", "lib/sportdb/utils_group.rb", "lib/sportdb/utils_map.rb", "lib/sportdb/utils_record.rb", "lib/sportdb/utils_round.rb", "lib/sportdb/utils_scores.rb", "lib/sportdb/utils_teams.rb", "lib/sportdb/version.rb", "test/data/at-austria/2013_14/bl.txt", "test/data/at-austria/2013_14/bl.yml", "test/data/at-austria/2013_14/bl_ii.txt", "test/data/at-austria/2013_14/el.txt", "test/data/at-austria/2013_14/el.yml", "test/data/at-austria/leagues.txt", "test/data/at-austria/teams.txt", "test/data/at-austria/teams_2.txt", "test/data/players/europe/de-deutschland/players.txt", "test/data/players/south-america/br-brazil/players.txt", "test/data/world-cup/1930/cup.txt", "test/data/world-cup/1930/cup.yml", "test/data/world-cup/1954/cup.txt", "test/data/world-cup/1954/cup.yml", "test/data/world-cup/1962/cup.txt", "test/data/world-cup/1962/cup.yml", "test/data/world-cup/1974/cup.yml", "test/data/world-cup/1974/cup_finals.txt", "test/data/world-cup/1974/cup_i.txt", "test/data/world-cup/1974/cup_ii.txt", "test/data/world-cup/2014/cup.txt", "test/data/world-cup/2014/cup.yml", "test/data/world-cup/2014/squads/br-brazil.txt", "test/data/world-cup/2014/squads/de-deutschland.txt", "test/data/world-cup/leagues.txt", "test/data/world-cup/seasons_1930.txt", "test/data/world-cup/seasons_1954.txt", "test/data/world-cup/seasons_1962.txt", "test/data/world-cup/seasons_1974.txt", "test/data/world-cup/teams_1930.txt", "test/data/world-cup/teams_1954.txt", "test/data/world-cup/teams_1962.txt", "test/data/world-cup/teams_1974.txt", "test/helper.rb", "test/test_changes.rb", "test/test_cursor.rb", "test/test_date.rb", "test/test_lang.rb", "test/test_load.rb", "test/test_national_team_reader.rb", "test/test_reader.rb", "test/test_round_auto.rb", "test/test_round_def.rb", "test/test_round_header.rb", "test/test_scores.rb", "test/test_standings.rb", "test/test_utils.rb", "test/test_winner.rb", ".gemtest"]
  s.homepage = "https://github.com/geraldb/sport.db.ruby"
  s.licenses = ["Public Domain"]
  s.post_install_message = "******************************************************************************\n\nQuestions? Comments? Send them along to the mailing list.\nhttps://groups.google.com/group/opensport\n\n******************************************************************************\n"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "1.8.17"
  s.summary = "sportdb - sport.db command line tool"
  s.test_files = ["test/test_date.rb", "test/test_lang.rb", "test/test_load.rb", "test/test_cursor.rb", "test/test_standings.rb", "test/test_scores.rb", "test/test_winner.rb", "test/test_round_def.rb", "test/test_utils.rb", "test/test_round_header.rb", "test/test_round_auto.rb", "test/test_national_team_reader.rb", "test/test_reader.rb", "test/test_changes.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<props>, [">= 0"])
      s.add_runtime_dependency(%q<logutils>, [">= 0"])
      s.add_runtime_dependency(%q<textutils>, [">= 0"])
      s.add_runtime_dependency(%q<worlddb>, [">= 2.0.2"])
      s.add_runtime_dependency(%q<tagutils>, [">= 0"])
      s.add_runtime_dependency(%q<persondb>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord-utils>, [">= 0"])
      s.add_runtime_dependency(%q<fetcher>, [">= 0.3"])
      s.add_runtime_dependency(%q<gli>, [">= 2.5.6"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.11"])
    else
      s.add_dependency(%q<props>, [">= 0"])
      s.add_dependency(%q<logutils>, [">= 0"])
      s.add_dependency(%q<textutils>, [">= 0"])
      s.add_dependency(%q<worlddb>, [">= 2.0.2"])
      s.add_dependency(%q<tagutils>, [">= 0"])
      s.add_dependency(%q<persondb>, [">= 0"])
      s.add_dependency(%q<activerecord-utils>, [">= 0"])
      s.add_dependency(%q<fetcher>, [">= 0.3"])
      s.add_dependency(%q<gli>, [">= 2.5.6"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.11"])
    end
  else
    s.add_dependency(%q<props>, [">= 0"])
    s.add_dependency(%q<logutils>, [">= 0"])
    s.add_dependency(%q<textutils>, [">= 0"])
    s.add_dependency(%q<worlddb>, [">= 2.0.2"])
    s.add_dependency(%q<tagutils>, [">= 0"])
    s.add_dependency(%q<persondb>, [">= 0"])
    s.add_dependency(%q<activerecord-utils>, [">= 0"])
    s.add_dependency(%q<fetcher>, [">= 0.3"])
    s.add_dependency(%q<gli>, [">= 2.5.6"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.11"])
  end
end
