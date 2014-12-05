require 'hoe'
require './lib/sportdb/version.rb'

## NB: plugin (hoe-manifest) not required; just used for future testing/development
## Hoe::plugin :manifest   # more options for manifests (in the future; not yet)


Hoe.spec 'sportdb-models' do

  self.version = SportDb::VERSION

  self.summary = "sportdb-models - sport.db schema 'n' models for easy (re)use"
  self.description = summary

  self.urls    = ['https://github.com/sportdb/sport.db.models']

  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  #  -- NB: auto-changed when included in manifest
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['props' ],
    ['logutils'],
    ['textutils'],
    ['tagutils'],     # tags n tagging tables
    ['worlddb-models', '>= 2.1.0'],  # NB: worlddb already includes logutils, textutils etc.
    ['persondb', '>= 0.4.0'],     # persons (people) table
    ['activerecord-utils'],   # extras e.g. rnd, find_by! for 3.x etc.
    ['logutils-activerecord'],
    ['props-activerecord'],
    ## 3rd party
    ['activerecord'],  # NB: will include activesupport,etc.

    ## ['fetcher', '>= 0.4.4'],
    ## ['datafile', '>= 0.1.1'],

    ### sportdb addons
    ## ['sportdb-keys'],
    ## ['sportdb-console'],
    ## ['sportdb-update'],
    ## ['sportdb-service'],

    ## ['gli', '>= 2.12.2'],

    ### ['sqlite3',      '~> 1.3']  # NB: install on your own; remove dependency
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 1.9.2'
  }

end

