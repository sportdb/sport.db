##  zip? not getting used? remove - why? why not?
  ZIP_RE = %r{ \.zip$
              }ix   ## note: allow .ZIP to (ignore case)
  def self.match_zip( path, pattern: ZIP_RE ) pattern.match( path ); end
  class << self    ## check if module << self is possible? (like class << self) - check if there's a better / more idomatic way??
    alias_method :match_zip?, :match_zip
    alias_method :zip?,       :match_zip
  end
