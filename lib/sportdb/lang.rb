# encoding: utf-8

module SportDb

class Lang

  include LogUtils::Logging

  attr_reader :lang

  def initialize
    # fix/todo: load on demand; only if no fixtures loaded/configured use builtin
    load_builtin_words
  end


  def load_builtin_words
    builtin_words = {
      'en' => 'fixtures/en',
      'de' => 'fixtures/de',
      'es' => 'fixtures/es'
    }

    load_words( builtin_words, SportDb.config_path )
  end

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

  def lang=(value)
    logger.debug "setting lang to #{value}"
    
    if @lang != value
      
      ### todo: make reset cached values into method/function for reuse (see load_words)
      # reset cached values on language change
      logger.debug "reseting cached lang values (lang changed from #{@lang} to #{value})"

      @cache = {}
    end
    
    @lang = value
    
  end


  def group
    @cache[ :group ] ||= group_getter
  end
  
  def round
    @cache[ :round ] ||= round_getter
  end

  def knockout_round
    @cache[ :knockout_round ] ||= knockout_round_getter
  end
  
  def leg1
    @cache[ :leg1 ] ||= leg1_getter
  end
  
  def leg2
    @cache[ :leg2 ] ||= leg2_getter
  end



  def regex_group
    @cache [ :regex_group ] ||= regex_group_getter
  end

  def regex_round
    @cache[ :regex_round ] ||= regex_round_getter
  end

  def regex_knockout_round
    @cache[ :regex_knockout_round ] ||= regex_knockout_round_getter
  end
  
  def regex_leg1
    @cache[ :regex_leg1 ] ||= regex_leg1_getter
  end
  
  def regex_leg2
    @cache[ :regex_leg2 ] ||= regex_leg2_getter
  end

private
  def group_getter
    h = @words[ lang ]
    values = ""   # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['group']
    values
  end

  def round_getter
    # e.g. Spieltag|Runde|Achtelfinale|Viertelfinale|Halbfinale|Finale
    
    h = @words[ lang ]
    values = ""   # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['round']
    values << "|" << h['matchday']  ## todo/check: fold round n matchday into one key? why? why not??
    
    ### add knockout rounds values too
    values << "|" << h['round32']
    values << "|" << h['round16']
    values << "|" << h['quarterfinals']
    values << "|" << h['semifinals']
    values << "|" << h['thirdplace']
    values << "|" << h['final']
    values
  end

  def leg1_getter
    h = @words[ lang ]
    values = ""  # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['leg1']
    values
  end

  def leg2_getter
    h = @words[ lang ]
    values = ""  # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['leg2']
    values
  end

  def knockout_round_getter
    h = @words[ lang ]
    values = ""  # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['round32']
    values << "|" << h['round16']
    values << "|" << h['quarterfinals']
    values << "|" << h['semifinals']
    values << "|" << h['thirdplace']
    values << "|" << h['final']
    values
  end
  
  def regex_group_getter
    ## todo: escape for regex?
    /#{group}/
  end
  
  def regex_round_getter
    ## todo: escape for regex?
    ## todo: sort by length - biggest words go first? does regex match biggest word automatically?? - check
    /#{round}/
  end

  def regex_knockout_round_getter
    ## todo: escape for regex?
    /#{knockout_round}/
  end
  
  def regex_leg1_getter
    ## todo: escape for regex?
    /#{leg1}/
  end

  def regex_leg2_getter
    ## todo: escape for regex?
    /#{leg2}/
  end

end # class Lang


end # module SportDb
