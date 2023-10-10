require 'hoe'
require './lib/persondb/version.rb'

Hoe.spec 'persondb-models' do

  self.version = PersonDb::VERSION

  self.summary = "persondb-models - person schema 'n' models for easy (re)use"
  self.description = summary

  self.urls    = ['https://github.com/persondb/person.db.models']

  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['worlddb-models']    ## get all (extra) dependencies via worlddb-models
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 1.9.2'
  }

end

