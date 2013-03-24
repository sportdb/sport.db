# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sportdb"
  s.version = "1.6.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gerald Bauer"]
  s.date = "2013-03-24"
  s.description = "sportdb - sport.db command line tool"
  s.email = "opensport@googlegroups.com"
  s.executables = ["sportdb"]
  s.extra_rdoc_files = ["Manifest.txt"]
  s.files = ["History.md", "Manifest.txt", "README.md", "Rakefile", "bin/sportdb", "config/fixtures.de.yml", "config/fixtures.en.yml", "config/fixtures.es.yml", "config/fixtures.pt.yml", "lib/sportdb.rb", "lib/sportdb/cli/main.rb", "lib/sportdb/cli/opts.rb", "lib/sportdb/console.rb", "lib/sportdb/data/fixtures.rb", "lib/sportdb/data/keys.rb", "lib/sportdb/data/models.rb", "lib/sportdb/deleter.rb", "lib/sportdb/lang.rb", "lib/sportdb/models/badge.rb", "lib/sportdb/models/city.rb", "lib/sportdb/models/continent.rb", "lib/sportdb/models/country.rb", "lib/sportdb/models/event.rb", "lib/sportdb/models/event_team.rb", "lib/sportdb/models/forward.rb", "lib/sportdb/models/game.rb", "lib/sportdb/models/goal.rb", "lib/sportdb/models/group.rb", "lib/sportdb/models/group_team.rb", "lib/sportdb/models/league.rb", "lib/sportdb/models/player.rb", "lib/sportdb/models/prop.rb", "lib/sportdb/models/region.rb", "lib/sportdb/models/round.rb", "lib/sportdb/models/season.rb", "lib/sportdb/models/team.rb", "lib/sportdb/reader.rb", "lib/sportdb/schema.rb", "lib/sportdb/stats.rb", "lib/sportdb/utils.rb", "lib/sportdb/version.rb", "tasks/test.rb", "test/helper.rb", "test/test_lang.rb", "test/test_round.rb", "test/test_utils.rb", ".gemtest"]
  s.homepage = "https://github.com/geraldb/sport.db.ruby"
  s.licenses = ["Public Domain"]
  s.post_install_message = "******************************************************************************\n\nQuestions? Comments? Send them along to the mailing list.\nhttps://groups.google.com/group/opensport\n\n******************************************************************************\n"
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "sportdb"
  s.rubygems_version = "1.8.17"
  s.summary = "sportdb - sport.db command line tool"
  s.test_files = ["test/test_lang.rb", "test/test_round.rb", "test/test_utils.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<worlddb>, ["~> 1.6"])
      s.add_runtime_dependency(%q<commander>, ["~> 4.1.3"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<hoe>, ["~> 3.3"])
    else
      s.add_dependency(%q<worlddb>, ["~> 1.6"])
      s.add_dependency(%q<commander>, ["~> 4.1.3"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<hoe>, ["~> 3.3"])
    end
  else
    s.add_dependency(%q<worlddb>, ["~> 1.6"])
    s.add_dependency(%q<commander>, ["~> 4.1.3"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<hoe>, ["~> 3.3"])
  end
end
