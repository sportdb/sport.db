
def load_words( h, include_path )
  @lang = 'en'   # make default lang english/en
  @words = {}  # resets fixtures
  @cache = {}  # reset cached values

  h.each_with_index do |(key,value),i|
    name = value
    path = "#{include_path}/#{name}.yml"
    logger.debug( "loading words #{key} (#{i+1}/#{h.size}) in '#{name}' (#{path})..." )
    @words[ key ] = YAML.load( File.read_utf8( path ))
  end

  @classifier = TextUtils::Classifier.new
  @words.each_with_index do |(key,value),i|
    logger.debug "train classifier for #{key} (#{i+1}/#{@words.size})"
    @classifier.train( key, value )
  end

  @classifier.dump  # for debugging dump all words
end

def classify( text )
  @classifier.classify( text )
end

def classify_file( path )
  @classifier.classify_file( path )
end
