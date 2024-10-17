module Sports

##
#  note: check that shape/structure/fields/attributes match
#            the ActiveRecord model !!!!

## add city here
##   use module World - why? why not?

class City
  attr_reader   :key, :name, :country
  attr_accessor :alt_names

  def initialize( key: nil,
                  name:, country: )
    ## note: auto-generate key "on-the-fly" if missing for now - why? why not?
    ## note: quick hack - auto-generate key, that is, remove all non-ascii chars and downcase
    @key       = key || unaccent(name).downcase.gsub( /[^a-z]/, '' ) + "_" + country.key
    @name      = name
    @country   = country
    @alt_names = []
  end
end  # class City



class Country

  ## note: is read-only/immutable for now - why? why not?
  ##          add cities (array/list) - why? why not?
  attr_reader   :key, :name, :code, :tags
  attr_accessor :alt_names

  def initialize( key: nil, name:, code:, tags: [] )
    ## note: auto-generate key "on-the-fly" if missing for now - why? why not?
    ## note: quick hack - auto-generate key, that is, remove all non-ascii chars and downcase
    @key = begin
              if key
                key
              elsif code
                 code.downcase
              else
                 unaccent( name ).downcase.gsub( /[^a-z]/, '' )
              end
            end
    @name, @code = name, code
    @alt_names      = []
    @tags           = tags
  end


  #############################
  ### virtual helpers
  ##    1) codes  (returns uniq array of all codes in lowercase
  ##               incl. key, code and alt_codes in alt_names)
  ##    2) names  (returns uniq array of all names - with language tags stripped)
  ##
  ##    3a) adjective/adj   - might be nil??
  ##     b) adjectives/adjs

  ##  note - alt_names - returns all-in-one alt names (& codes)

## note: split names into names AND codes
##      1)  key plus all lower case names are codes
##      2)    all upper case names are names AND codes
##      3)    all other names are names

## only allow asci a to z in code & name for now - why? why not?
##   e.g. USA, etc.
IS_CODE_N_NAME_RE = %r{^
                        [A-Z]+
                       $}x
## must be all lowercase (unicode letters allowed for now -  why? why not?
##   e.g. nirl, a, ö, etc.
IS_CODE_RE           = %r{^
                            [\p{Ll}]+
                        $}x

  def codes
       ## note - "auto-magically" downcase code (and code'n'name matches)!!!
      codes = [@key, @code.downcase]
      alt_names.each do |name|
        if IS_CODE_N_NAME_RE.match?( name )
          codes << name.downcase
        elsif IS_CODE_RE.match?( name )
          codes << name
        else ## assume name
          ## do nothing - skip/ignore
        end
      end
      codes.uniq
  end


   include SportDb::NameHelper   # pulls-in strip_lang

  def names
     names = [@name]
     alt_names.each do |name|
        if IS_CODE_N_NAME_RE.match?( name )
          names << name
        elsif IS_CODE_RE.match?( name )
          ## do nothing - skip/ignore
        else ## assume name
          names <<  strip_lang( name )
        end
    end
    names.uniq
  end

## country adjectives  - quick hack for now inline here
##
##  todo - add language marker - why? why not`
##          e.g.   Österr.   => Österr. [de]
##                 Deutsche` => Deutsche [de]
##
##
## todo/fix - add more - see
##     https://en.wikipedia.org/wiki/List_of_adjectival_and_demonymic_forms_for_countries_and_nations
ADJ = {
  'at'  => ['Österr.', 'Austrian'],
  'de'  => ['Deutsche', 'German'],
  'eng' => ['English'],
  'sco' => ['Scottish'],
  'wal' => ['Welsh'],
  'nir' => ['Northern Irish'],
  'ie'  => ['Irish'],

  'it'  => ['Italian'],
  'sm'  => ['San Marinese'],
  'fr'  => ['French'],
  'hu'  => ['Hungarian'],
  'gr'  => ['Greek'],
  'pt'  => ['Portuguese'],
  'ch'  => ['Swiss'],
  'tr'  => ['Turkish'],
}

  ## note - adjective might be nil!!!
  def adjective()  adjectives[0]; end
  def adjectives() ADJ[@key] || []; end

  alias_method :adj, :adjective
  alias_method :adjs, :adjectives

  def pretty_print( printer )
    buf = String.new
    buf << "<Country: #{@key} - #{@name} (#{@code})"
    buf << "|#{@alt_names.join('|')}"  if @alt_names && !@alt_names.empty?
    buf << ", #{@tags.join('|')})"     if @tags && !@tags.empty?
    buf << ">"

    printer.text( buf )
  end
end  # class Country

end   # module Sports

