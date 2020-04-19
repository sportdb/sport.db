# encoding: utf-8

module SportDb

##
## note: this was/is a cut-n-page (inline) copy of TextUtils::TitleMapper2
##   see https://github.com/textkit/textutils/blob/master/textutils/lib/textutils/title_mapper2.rb


class MapperV2      ## todo/check: rename to NameMapper/TitleMapper ? why? why not??

  include LogUtils::Logging

  attr_reader :known_titles   ## rename to mapping or mappings or just titles - why? why not?

  ########
  ##  key:      e.g. augsburg
  ##  title:    e.g. FC Augsburg
  ##  length (of title(!!) - not regex pattern):   e.g. 11   -- do not count dots (e.g. U.S.A. => 3 or 6) why? why not?
  MappingStruct =  Struct.new( :key, :title, :length, :pattern)     ## todo/check: use (rename to) TitleStruct - why? why not??

  ######
  ## convenience helper - (auto)build ActiveRecord-like club records/structs
  Record = Struct.new( :key, :title, :synonyms )
  def build_records( txt )
    recs = []
    txt.each_line do |line|
      line = line.strip

      next if line.empty? || line.start_with?( '#' )  ## note: skip empty and comment lines

      values = line.split( '|' )
      values = values.map { |value| value.strip }

      title    = values[0]
      ## note: quick hack - auto-generate key, that is, remove all non-ascii chars and downcase
      key      = title.downcase.gsub( /[^a-z]/, '' )
      synonyms = values.size > 1 ? values[1..-1].join( '|' ) : nil

      recs << Record.new( key, title, synonyms )
    end
    recs
  end


  def initialize( records_or_mapping, tag )
    ## for convenience allow easy (auto-)convert text (lines) to records
    records_or_mapping = build_records( records_or_mapping )   if records_or_mapping.is_a?( String )

    ## build mapping lookup table
    @known_titles =  if records_or_mapping.is_a?( Array )  ## assume array of records
                        build_title_table_for_records( records_or_mapping )
                     else  ## assume "custom" mapping hash table (title/name=>record)
                        build_title_table_for_mapping( records_or_mapping )
                     end

    ## build lookup hash by record (e.g. team/club/etc.) key
    records = if records_or_mapping.is_a?( Array )
                  records_or_mapping
              else   ## assume hash (uses values assuming to be all records - note might include duplicates)
                  records_or_mapping.values
              end

    @records = records.reduce({}) { |h,rec| h[rec.key]=rec; h }


    ## todo: rename tag to attrib or attrib_name - why ?? why not ???
    @tag = tag   # e.g. tag name use for @@brewery@@ @@team@@ etc.
  end



  def map_titles!( line )   ## rename to just map! - why?? why not???
    begin
      found = map_title_for!( @tag, line, @known_titles )
    end while found
  end

  def find_rec!( line )
    find_rec_for!( @tag, line, @records )
  end

  def find_recs!( line )  # note: keys (plural!) - will return array
    counter = 1
    recs = []

    rec = find_rec_for!( "#{@tag}#{counter}", line, @records )
    while rec
      recs << rec
      counter += 1
      rec = find_rec_for!( "#{@tag}#{counter}", line, @records )
    end
    recs
  end


private
  def build_title_table_for_mapping( mapping )
    known_titles = []

    mapping.each do |title, rec|
      m = MappingStruct.new
      m.key     = rec.key
      m.title   = title
      m.length  = title.length
      m.pattern = Regexp.escape( title )   ## note: just use "standard" regex escape (e.g. no extras for umlauts,accents,etc.)

      known_titles << m
    end

    ## note: sort here by length (largest goes first - best match)
    known_titles = known_titles.sort { |l,r| r.length <=> l.length }
    known_titles
  end

  def build_title_table_for_records( records )

    ## build known tracks table w/ synonyms e.g.
    #
    # [[ 'wolfsbrug', 'VfL Wolfsburg'],
    #  [ 'augsburg',  'FC Augsburg'],
    #  [ 'augsburg',  'Augi2'],
    #  [ 'augsburg',  'Augi3' ],
    #  [ 'stuttgart', 'VfB Stuttgart']]

    known_titles = []

    records.each_with_index do |rec,index|

      title_candidates = []
      title_candidates << rec.title

      title_candidates += rec.synonyms.split('|') if rec.synonyms && !rec.synonyms.empty?


      ## check if title includes subtitle e.g. Grand Prix Japan (Suzuka Circuit)
      #  make subtitle optional by adding title w/o subtitle e.g. Grand Prix Japan

      titles = []
      title_candidates.each do |t|
        titles << t
        if t =~ /\(.+\)/
          extra_title = t.gsub( /\(.+\)/, '' ) # remove/delete subtitles
          # note: strip leading n trailing withspaces too!
          #  -- todo: add squish or something if () is inline e.g. leaves two spaces?
          extra_title.strip!
          titles << extra_title
        end
      end

      titles.each do |t|
        m = MappingStruct.new
        m.key     = rec.key
        m.title   = t
        m.length  = t.length
        ## note: escape for regex plus allow subs for special chars/accents
        m.pattern = title_esc_regex( t )

        known_titles << m
      end

      logger.debug "  #{rec.class.name}[#{index+1}] #{rec.key} >#{titles.join('|')}<"

      ## note: only include code field - if defined
      if rec.respond_to?(:code) && rec.code && !rec.code.empty?
        m = MappingStruct.new
        m.key     = rec.key
        m.title   = rec.code
        m.length  = rec.code.length
        m.pattern = rec.code   ## note: use code for now as is (no variants allowed fow now)

        known_titles << m
      end
    end

    ## note: sort here by length (largest goes first - best match)
      #  exclude code and key (key should always go last)
    known_titles = known_titles.sort { |l,r| r.length <=> l.length }
    known_titles
  end



  def map_title_for!( tag, line, mappings )
    mappings.each do |mapping|
      key     = mapping.key
      pattern = mapping.pattern
      ## nb: \b does NOT include space or newline for word boundry (only alphanums e.g. a-z0-9)
      ## (thus add it, allows match for Benfica Lis.  for example - note . at the end)

      ## check add $ e.g. (\b| |\t|$) does this work? - check w/ Benfica Lis.$
      re = /\b#{pattern}(\b| |\t|$)/   # wrap with world boundry (e.g. match only whole words e.g. not wac in wacker)
      if line =~ re
        logger.debug "     match for #{tag.downcase}  >#{key}< >#{pattern}<"
        # make sure @@oo{key}oo@@ doesn't match itself with other key e.g. wacker, wac, etc.
        line.sub!( re, "@@oo#{key}oo@@ " )    # NB: add one space char at end
        return true    # break out after first match (do NOT continue)
      end
    end

    false
  end


  def find_rec_for!( tag, line, records )
    re = /@@oo([^@]+?)oo@@/     # e.g. everything in @@ .... @@ (use non-greedy +? plus all chars but not @, that is [^@])

    if line =~ re
      key = $1
      logger.debug "   #{tag.downcase}: >#{key}<"

      line.sub!( re, "[#{tag.upcase}]" )

      records[ key ]  ## note: map key to record (using records hash table mapping)
    else
      nil
    end
  end # method find_key_for!


####
# title helper cut-n-paste copy from TextUtils
##  see https://github.com/textkit/textutils/blob/master/textutils/lib/textutils/helper/title_helper.rb
def title_esc_regex( title_unescaped )

      ##  escape regex special chars e.g.
      #    . to \. and
      #    ( to \(
      #    ) to \)
      #    ? to \? -- zero or one
      #    * to \* -- zero or more
      #    + to \+ -- one or more
      #    $ to \$ -- end of line
      #    ^ to \^ -- start of line etc.

      ### add { and } ???
      ### add [ and ] ???
      ### add \ too ???
      ### add | too ???

      # e.g. Benfica Lis.
      # e.g. Club Atlético Colón (Santa Fe)
      # e.g. Bauer Anton (????)

      ## NB: cannot use Regexp.escape! will escape space '' to '\ '
      ## title = Regexp.escape( title_unescaped )
      title = title_unescaped.gsub( '.', '\.' )
      title = title.gsub( '(', '\(' )
      title = title.gsub( ')', '\)' )
      title = title.gsub( '?', '\?' )
      title = title.gsub( '*', '\*' )
      title = title.gsub( '+', '\+' )
      title = title.gsub( '$', '\$' )
      title = title.gsub( '^', '\^' )

      ##  match accented char with or without accents
      ##  add (ü|ue) etc.
      ## also make - optional change to (-| ) e.g. Blau-Weiss == Blau Weiss

      ## todo: add some more
      ## see http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references  for more
      ##
      ##  reuse for all readers!

      alternatives = [
        ['-', '(-| )'],  ## e.g. Blau-Weiß Linz
        ['æ', '(æ|ae)'],  ## e.g.
        ['ä', '(ä|ae)'],  ## e.g.
        ['Ö', '(Ö|Oe)'],  ## e.g. Österreich
        ['ö', '(ö|oe)'],  ## e.g. Mönchengladbach
        ['ß', '(ß|ss)'],  ## e.g. Blau-Weiß Linz
        ['ü', '(ü|ue)'],  ## e.g.

        ['á', '(á|a)'],  ## e.g. Bogotá, Sársfield
        ['ã', '(ã|a)'],  ## e.g  São Paulo
        ['ç', '(ç|c)'],  ## e.g. Fenerbahçe
        ['é', '(é|e)'],  ## e.g. Vélez
        ['ê', '(ê|e)'],  ## e.g. Grêmio
        ['ï', '(ï|i)' ], ## e.g. El Djazaïr
        ['ñ', '(ñ|n)'],  ## e.g. Porteño
        ['ň', '(ň|n)'],  ## e.g. Plzeň
        ['ó', '(ó|o)'],   ## e.g. Colón
        ['ō', '(ō|o)'],  # # e.g. Tōkyō
        ['ș', '(ș|s)'],   ## e.g. Bucarești
        ['ú', '(ú|u)']  ## e.g. Fútbol
      ]

      ### fix/todo:  check for  dot+space e.g. . and make dot optional
      ##
      #  e.g. make  dot (.) optional plus allow alternative optional space e.g.
      #   -- for U.S.A. => allow USA or U S A
      #
      ##    e.g. U. de G. or U de G or U.de G. ??
      ##   collect some more (real-world) examples first!!!!!

      alternatives.each do |alt|
        title = title.gsub( alt[0], alt[1] )
      end

      title
  end

end # class MapperV2
end # module SportDb
