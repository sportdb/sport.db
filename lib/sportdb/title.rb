# encoding: utf-8

################
# todo: move module to textutils!!!

### fix: move to textutils??


## todo: rename to  TitleHelpers? TitleMatcher? TitleMapper? TitleMapping? TitleMappings? TitleFinder? TitleHelpers?
#   or rename to KeyMapping?, KeyMapper?, KeyTable? etc.


module TextUtils::TitleTable


def build_title_table_for( records )
    ## build known tracks table w/ synonyms e.g.
    #
    # [[ 'wolfsbrug', [ 'VfL Wolfsburg' ]],
    #  [ 'augsburg',  [ 'FC Augsburg', 'Augi2', 'Augi3' ]],
    #  [ 'stuttgart', [ 'VfB Stuttgart' ]] ]

    known_titles = []

    records.each_with_index do |rec,index|

      titles = []
      titles << rec.title
      titles += rec.synonyms.split('|') if rec.synonyms.present?
      
      ## NB: sort here by length (largest goes first - best match)
      #  exclude code and key (key should always go last)
      titles = titles.sort { |left,right| right.length <=> left.length }
      
      ## escape for regex plus allow subs for special chars/accents
      titles = titles.map { |title| TextUtils.title_esc_regex( title )  }

      ## NB: only include code field - if defined
      titles << rec.code          if rec.respond_to?(:code) && rec.code.present?

      known_titles << [ rec.key, titles ]

      ### fix: use plain logger
      LogUtils::Logger.root.debug "  #{rec.class.name}[#{index+1}] #{rec.key} >#{titles.join('|')}<"
    end

    known_titles
end



def find_key_for!( name, line )
  regex = /@@oo([^@]+?)oo@@/     # e.g. everything in @@ .... @@ (use non-greedy +? plus all chars but not @, that is [^@])

  upcase_name   = name.upcase
  downcase_name = name.downcase

  if line =~ regex
    value = "#{$1}"
    ### fix: use plain logger
    LogUtils::Logger.root.debug "   #{downcase_name}: >#{value}<"
      
    line.sub!( regex, "[#{upcase_name}]" )

    return $1
  else
    return nil
  end
end


def find_keys_for!( name, line )  # NB: keys (plural!) - will return array
  counter = 1
  keys = []

  downcase_name = name.downcase

  key = find_key_for!( "#{downcase_name}#{counter}", line )
  while key.present?
    keys << key
    counter += 1
    key = find_key_for!( "#{downcase_name}#{counter}", line )
  end

  keys
end


def map_titles_for!( name, line, title_table )
  title_table.each do |rec|
    key    = rec[0]
    values = rec[1]
    map_title_worker_for!( name, line, key, values )
  end
end


def map_title_worker_for!( name, line, key, values )

  downcase_name = name.downcase

  values.each do |value|
    ## nb: \b does NOT include space or newline for word boundry (only alphanums e.g. a-z0-9)
    ## (thus add it, allows match for Benfica Lis.  for example - note . at the end)

    ## check add $ e.g. (\b| |\t|$) does this work? - check w/ Benfica Lis.$
    regex = /\b#{value}(\b| |\t|$)/   # wrap with world boundry (e.g. match only whole words e.g. not wac in wacker) 
    if line =~ regex
      ### fix: use plain logger
      LogUtils::Logger.root.debug "     match for #{downcase_name}  >#{key}< >#{value}<"
      # make sure @@oo{key}oo@@ doesn't match itself with other key e.g. wacker, wac, etc.
      line.sub!( regex, "@@oo#{key}oo@@ " )    # NB: add one space char at end
      return true    # break out after first match (do NOT continue)
    end
  end
  return false
end



end # module TextUtils::TitleTable



## auto-include methods

module TextUtils
  # make helpers available as class methods e.g. TextUtils.convert_unicode_dashes_to_plain_ascii
  extend TitleTable  # lets us use TextUtils.build_title_table_for etc.
end
