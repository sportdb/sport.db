# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sportdb"
  s.version = "1.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gerald Bauer"]
  s.date = "2014-02-09"
  s.description = "sportdb - sport.db command line tool"
  s.email = "opensport@googlegroups.com"
  s.executables = ["sportdb"]
  s.extra_rdoc_files = ["History.md", "Manifest.txt", "README.md"]
  s.files = ["History.md", "Manifest.txt", "README.md", "Rakefile", "bin/sportdb", "config/fixtures/de.yml", "config/fixtures/en.yml", "config/fixtures/es.yml", "config/fixtures/pt.yml", "data/seasons.txt", "data/setups/all.yml", "lib/sportdb.rb", "lib/sportdb/cli/main.rb", "lib/sportdb/cli/opts.rb", "lib/sportdb/console.rb", "lib/sportdb/data/keys.rb", "lib/sportdb/data/models.rb", "lib/sportdb/deleter.rb", "lib/sportdb/lang.rb", "lib/sportdb/models/badge.rb", "lib/sportdb/models/event.rb", "lib/sportdb/models/event_team.rb", "lib/sportdb/models/forward.rb", "lib/sportdb/models/game.rb", "lib/sportdb/models/goal.rb", "lib/sportdb/models/group.rb", "lib/sportdb/models/group_team.rb", "lib/sportdb/models/league.rb", "lib/sportdb/models/person.rb", "lib/sportdb/models/race.rb", "lib/sportdb/models/record.rb", "lib/sportdb/models/roster.rb", "lib/sportdb/models/round.rb", "lib/sportdb/models/run.rb", "lib/sportdb/models/season.rb", "lib/sportdb/models/team.rb", "lib/sportdb/models/track.rb", "lib/sportdb/models/utils.rb", "lib/sportdb/models/world/city.rb", "lib/sportdb/models/world/continent.rb", "lib/sportdb/models/world/country.rb", "lib/sportdb/models/world/region.rb", "lib/sportdb/reader.rb", "lib/sportdb/schema.rb", "lib/sportdb/service.rb", "lib/sportdb/service/public/football/js/football/api.js", "lib/sportdb/service/public/football/js/football/plugin.js", "lib/sportdb/service/public/football/js/football/widget.js", "lib/sportdb/service/public/football/js/libs/jquery-2.0.2.min.js", "lib/sportdb/service/public/football/js/libs/require-2.1.6.js", "lib/sportdb/service/public/football/js/libs/underscore-1.4.4.min.js", "lib/sportdb/service/public/football/js/text.js", "lib/sportdb/service/public/football/js/utils.js", "lib/sportdb/service/public/football/matchday-jquery.html", "lib/sportdb/service/public/football/matchday-template.html", "lib/sportdb/service/public/football/matchday.html", "lib/sportdb/service/public/football/templates/event.html", "lib/sportdb/service/public/football/templates/games.html", "lib/sportdb/service/public/football/templates/rounds-long.html", "lib/sportdb/service/public/football/templates/rounds-short.html", "lib/sportdb/service/public/football/templates/rounds-today.html", "lib/sportdb/service/public/style.css", "lib/sportdb/service/public/style.css.scss", "lib/sportdb/service/server.rb", "lib/sportdb/service/version.rb", "lib/sportdb/service/views/_debug.erb", "lib/sportdb/service/views/_football_head.erb", "lib/sportdb/service/views/_football_live.erb", "lib/sportdb/service/views/_football_today.erb", "lib/sportdb/service/views/_usage.erb", "lib/sportdb/service/views/_version.erb", "lib/sportdb/service/views/debug.erb", "lib/sportdb/service/views/index.erb", "lib/sportdb/service/views/layout.erb", "lib/sportdb/stats.rb", "lib/sportdb/title.rb", "lib/sportdb/updater.rb", "lib/sportdb/utils.rb", "lib/sportdb/version.rb", "test/helper.rb", "test/test_changes.rb", "test/test_cursor.rb", "test/test_date.rb", "test/test_lang.rb", "test/test_round.rb", "test/test_scores.rb", "test/test_utils.rb", "test/test_winner.rb", ".gemtest"]
  s.homepage = "https://github.com/geraldb/sport.db.ruby"
  s.licenses = ["Public Domain"]
  s.post_install_message = "******************************************************************************\n\nQuestions? Comments? Send them along to the mailing list.\nhttps://groups.google.com/group/opensport\n\n******************************************************************************\n"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "sportdb"
  s.rubygems_version = "1.8.16"
  s.summary = "sportdb - sport.db command line tool"
  s.test_files = ["test/test_changes.rb", "test/test_cursor.rb", "test/test_date.rb", "test/test_lang.rb", "test/test_round.rb", "test/test_scores.rb", "test/test_utils.rb", "test/test_winner.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<worlddb>, [">= 1.7"])
      s.add_runtime_dependency(%q<fetcher>, [">= 0.3"])
      s.add_runtime_dependency(%q<gli>, [">= 2.5.6"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.7"])
    else
      s.add_dependency(%q<worlddb>, [">= 1.7"])
      s.add_dependency(%q<fetcher>, [">= 0.3"])
      s.add_dependency(%q<gli>, [">= 2.5.6"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.7"])
    end
  else
    s.add_dependency(%q<worlddb>, [">= 1.7"])
    s.add_dependency(%q<fetcher>, [">= 0.3"])
    s.add_dependency(%q<gli>, [">= 2.5.6"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.7"])
  end
end
