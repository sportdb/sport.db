

# load built-in (that is, bundled within the gem) named seeds
# - pass in an array of seed names e.g. [ 'cl/teams', 'cl/2012_13/cl' ] etc.

def self.load( ary )
  loader = Loader.new
    ary.each do |name|
      loader.load_fixtures_builtin( name )
    end
  end
end



### old version; new version moved to Reader.load_with_include_path

# load built-in (that is, bundled within the gem) named plain text seeds
  # - pass in an array of pairs of event/seed names e.g.
  #   [['at.2012/13', 'at/2012_13/bl'],
  #    ['cl.2012/13', 'cl/2012_13/cl']] etc.

  def self.read( ary )
    reader = Reader.new
    ary.each do |rec|
      ## todo: check for teams in name too?
      if rec[1].nil? || rec[1].kind_of?( Hash )   ## assume team fixtures
        reader.load_teams_builtin( rec[0], rec[1] )  ## NB: name goes first than opt more_values hash
      else
        reader.load_fixtures_builtin( rec[0], rec[1] ) # event_key, name  -- assume game fixtures
      end
    end
  end