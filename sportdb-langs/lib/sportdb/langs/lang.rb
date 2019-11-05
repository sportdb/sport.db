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
    langs = %w[en de es fr it pt ro]

    load_words( langs, SportDb::Langs.config_path )
  end


  def load_words( langs, include_path )
    @lang  = 'en'   # make default lang english/en
    @words = {}     # resets fixtures
    @cache = {}     # reset cached values

    langs.each_with_index do |lang,i|
      path = "#{include_path}/#{lang}.yml"
      logger.debug( "loading words #{lang} (#{i+1}/#{langs.size}) in (#{path})..." )
      @words[ lang ] = YAML.load( File.open( path, 'r:utf-8' ).read )
      @cache[ lang ] = {}   ## setup empty cache (hash)
    end
  end


  def lang=(value)
    logger.debug "setting lang to #{value}"

    @lang = value.to_s   # note: make sure it's a string (not a symbol) - fix: use symbol internally - why? why not?
    @lang
  end


  def group()           @cache[ @lang ][ :group ] ||= build_group;  end
  def round()           @cache[ @lang ][ :round ] ||= build_round;  end
  def knockout_round()  @cache[ @lang ][ :knockout_round ] ||= build_knockout_round;  end
  def leg1()            @cache[ @lang ][ :leg1 ] ||= build_leg1; end
  def leg2()            @cache[ @lang ][ :leg2 ] ||= build_leg2; end


  ## regex helpers
  ## todo/fix: escape for regex?
  ## note: let's ignore case (that is, UPCASE,downcase); always use /i flag
  ## todo: escape for regex?
  ## todo/fix: sort by length - biggest words go first? does regex match biggest word automatically?? - check
  ##  todo/fix: make - optional e.g. convert to ( |-) or better [ \-] ??
  ## note: let's ignore case (that is, UPCASE,downcase); always use /i flag
  ## todo/fix: escape for regex?
  ## todo/fix: sort by length - biggest words go first? does regex match biggest word automatically?? - check
  ##  todo/fix: make - optional e.g. convert to ( |-) or better [ \-] ??
  ## note: let's ignore case (that is, UPCASE,downcase); always use /i flag
  ## todo/fix: escape for regex?
  ## note: let's ignore case (that is, UPCASE,downcase); always use /i flag
  ## todo/fix: escape for regex?
  ## note: let's ignore case (that is, UPCASE,downcase); always use /i flag
  def group_re()           @cache[ @lang ][ :group_re ] ||= /#{group}/i; end
  def round_re()           @cache[ @lang ][ :round_re ] ||= /#{round}/i; end
  def knockout_round_re()  @cache[ @lang ][ :knockout_round_re ] ||= /#{knockout_round}/i; end
  def leg1_re()            @cache[ @lang ][ :leg1_re ] ||= /#{leg1}/i; end
  def leg2_re()            @cache[ @lang ][ :leg2_re ] ||= /#{leg2}/i; end

  ## "old" names - deprecated -remove latter!!!!
  alias_method :regex_group,          :group_re
  alias_method :regex_round,          :round_re
  alias_method :regex_knockout_round, :knockout_round_re
  alias_method :regex_leg1,           :leg1_re
  alias_method :regex_leg2,           :leg2_re


  def build_group
    h = @words[ @lang ]
    values = ""   # Note: always construct a new string (do NOT use a reference to hash value)
    values << h['group']
    values
  end

  def build_round
    # e.g. Spieltag|Runde|Achtelfinale|Viertelfinale|Halbfinale|Finale

    ## fix/todo:
    ##  sort by length first - to allow best match e.g.
    ##    3rd place play-off  instead of Play-off ?? etc.  - why? why not?
    h = @words[ @lang ]
    values = ""   # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['round']

    ### add knockout rounds values too
    values << "|" << h['round32']
    values << "|" << h['round16']
    values << "|" << h['quarterfinals']
    values << "|" << h['semifinals']
    values << "|" << h['fifthplace']  if h['fifthplace']   # nb: allow empty/is optional!!
    values << "|" << h['thirdplace']
    values << "|" << h['final']
    values << "|" << h['playoffs']    if h['playoffs']   # nb: allow empty/is optional!!
    values
  end

  def build_leg1
    h = @words[ @lang ]
    values = ""  # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['leg1']
    values
  end

  def build_leg2
    h = @words[ @lang ]
    values = ""  # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['leg2']
    values
  end

  def build_knockout_round
    h = @words[ @lang ]
    values = ""  # NB: always construct a new string (do NOT use a reference to hash value)
    values << h['round32']
    values << "|" << h['round16']
    values << "|" << h['quarterfinals']
    values << "|" << h['semifinals']
    values << "|" << h['fifthplace']  if h['fifthplace']   # nb: allow empty/is optional!!
    values << "|" << h['thirdplace']
    values << "|" << h['final']
    values << "|" << h['playoffs']    if h['playoffs']   # nb: allow empty/is optional!!
    values
  end

end # class Lang
end # module SportDb
