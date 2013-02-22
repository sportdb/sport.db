# encoding: utf-8

module SportDB

class Lang

  def logger
    @logger ||= LogUtils[ self ]
  end

  def initialize

    @lang = 'en'   # make default lang english/en

    # load word lists

    @fixtures_en = YAML.load( File.read_utf8( "#{SportDB.config_path}/fixtures.en.yml" ))
    @fixtures_de = YAML.load( File.read_utf8( "#{SportDB.config_path}/fixtures.de.yml" ))
    @fixtures_es = YAML.load( File.read_utf8( "#{SportDB.config_path}/fixtures.es.yml" ))

    @fixtures = {
      'en' => @fixtures_en,
      'de' => @fixtures_de,
      'es' => @fixtures_es,
    }


    @words_en = fixtures_hash_to_words_ary( @fixtures_en )
    @words_de = fixtures_hash_to_words_ary( @fixtures_de )
    @words_es = fixtures_hash_to_words_ary( @fixtures_es )
    
    puts "en - #{@words_en.size} words: #{@words_en}"
    puts "de - #{@words_de.size} words: #{@words_de}"
    puts "es - #{@words_es.size} words: #{@words_es}"
    
  end

  attr_reader :words_en
  attr_reader :words_de
  attr_reader :words_es
  attr_reader :lang

  def lang=(value)
    logger.debug "setting lang to #{value}"
    
    if @lang != value
      # reset cached values on language change
      logger.debug "reseting cached lang values (lang changed from #{@lang} to #{value})"

      @group = nil
      @round = nil
      @knockout_round = nil
      @leg1 = nil
      @leg2 = nil
      
      @regex_group = nil
      @regex_round = nil
      @regex_knockout_round = nil
      @regex_leg1 = nil
      @regex_leg2 = nil
    end
    
    @lang = value
    
  end


  def group
    @group ||= group_getter
  end
  
  def round
    @round ||= round_getter
  end
 
  def knockout_round
    @knock_round ||= knockout_round_getter
  end
  
  def leg1
    @leg1 ||= leg1_getter
  end
  
  def leg2
    @leg2 ||= leg2_getter
  end


  def regex_group
    @regex_group ||= regex_group_getter
  end
   
  def regex_round
    @regex_round ||= regex_round_getter
  end
  
  def regex_knockout_round
    @regex_knockout_round ||= regex_knockout_round_getter
  end
  
  def regex_leg1
    @regex_leg1 ||= regex_leg1_getter
  end
  
  def regex_leg2
    @regex_leg2 ||= regex_leg2_getter
  end
  
  
  
private
  def group_getter
    h = @fixtures[ lang ]
    values = h['group']
    values
  end
  
  def round_getter
    # e.g. Spieltag|Runde|Achtelfinale|Viertelfinale|Halbfinale|Finale
    
    h = @fixtures[ lang ]
    values = h['round']
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
    h = @fixtures[ lang ]
    values = h['leg1']
    values
  end

  def leg2_getter
    h = @fixtures[ lang ]
    values = h['leg2']
    values
  end

  def knockout_round_getter
    h = @fixtures[ lang ]
    values = h['round32']
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


  def fixtures_hash_to_words_ary( hash )
    ary = []
    hash.each do |key_wild, values_wild|
      key     = key_wild.to_s.strip
      values  = values_wild.to_s.strip
       
      logger.debug "processing key >>#{key}<< with words >>#{values}<<"
       
      ary += values.split('|')
    end
    ary
  end
  
end # class Lang


class LangChecker

  def logger
    @logger ||= LogUtils[ self ]
  end
  
  def initialize
  end

  def analyze( name, include_path )
    # return lang code e.g. en, de, es
    
    path = "#{include_path}/#{name}.txt"

    logger.info "parsing data '#{name}' (#{path})..."

    text = File.read_utf8( path )
    
    ### todo/fix:
    # remove comment lines and end of line comments from text
    
    en = count_words_in_text( SportDB.lang.words_en, text )
    de = count_words_in_text( SportDB.lang.words_de, text )
    es = count_words_in_text( SportDB.lang.words_es, text )
      
    lang_counts = [
      [ 'en', en ],
      [ 'de', de ],
      [ 'es', es ]
    ]
    
    # sort by word count (reverse sort e.g. highest count goes first)
    lang_counts = lang_counts.sort {|l,r| r[1] <=> l[1] }
    
    # dump stats
    
    logger.info "****************************************"
    lang_counts.each_with_index do |item,index|
      ## e.g. 1. en: 20 words
      ##      2. de: 2 words
      logger.info "#{index+1}. #{item[0]}: #{item[1]}"
    end
    
    ## return lang code w/ highest count
    lang_counts[0][0]
  end

private
  def count_word_in_text( word, text )
    count = 0
    pos = text.index( word )
    while pos.nil? == false
      count += 1
      logger.debug "bingo - found >>#{word}<< on pos #{pos}, count: #{count}"
      ### todo: check if pos+word.length/size needs +1 or similar
      pos = text.index( word, pos+word.length)
    end
    count
  end
  
  def count_words_in_text( words, text )
    count = 0
    words.each do |word|
      count += count_word_in_text( word, text )
    end
    count
  end

end # class LangChecker


end # module SportDB
