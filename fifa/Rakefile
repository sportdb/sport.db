require 'hoe'
require './lib/fifa/version.rb'

Hoe.spec 'fifa' do

  self.version = Fifa::VERSION

  self.summary = "fifa - the world's football countries and codes (incl. non-member countries and irregular codes)"
  self.description = summary

  self.urls = { home: 'https://github.com/sportdb/fifa' }

  self.author = 'Gerald Bauer'
  self.email = 'gerald.bauer@google.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'CHANGELOG.md'

  self.licenses = ['Public Domain']

  self.extra_deps = [
    ['sportdb-structs',   '>= 0.4.0'],
    ['alphabets'],
  ]

  self.spec_extras = {
    required_ruby_version: '>= 3.1.0'
  }

end
