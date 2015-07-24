# encoding: UTF-8

module SportDb


###
## reads in a text files
##   and tries to fix up/patch some parts


class Patcher

  include LogUtils::Logging

  def initialize( root, opts={} )
    @root  = root
    @path  = opts[:path] || opts[:paths]    # pass in regex as string
    @names = opts[:name] || opts[:names]    # pass in regex as string

    @path_regex  = Regexp.new( @path )  if @path
    @names_regex = Regexp.new( @names ) if @names
  end


  def find_files
    ## note: for now always filter by .txt extension
    files = Dir[ "#{@root}/**/*.txt" ]

    puts "before filter:"
    pp files

    files = files.select do |f|

      basename = File.basename( f )
      dirname  = File.dirname( f )   # note: add trailing slash
      dirname = "#{dirname}/"

      puts "  basename=>#{basename}<, dirname=>#{dirname}<"

      if @path_regex
        match_dirname =  @path_regex === dirname    # note: use === (triple) for true/false regex match
      else
        match_dirname = true
      end
      
      if @names_regex
        match_basename = @names_regex === basename
      else
        match_basename = true
      end

      match_basename && match_dirname
    end

    puts "after filter:"
    pp files

    files
  end # method find_files


  def patch( save=false)
    files = find_files
    change_logs = []

    files.each do |file|
      p = PrettyPrinter.from_file( file )
      new_text, change_log = p.patch
      
      next if change_log.empty?   ## no changes
      
      if save
        File.open( file, 'w' ) do |f|
          f.write new_text
        end
      end

      change_logs << [file, change_log]
    end

    change_logs  ## return change_logs or empty array
  end # method patch

end  ## class Patcher


class PrettyPrinter
  
  include LogUtils::Logging

  def self.from_file( path, opts={} )
    ## note: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
    self.from_string( text, opts )
  end

  def self.from_string( text, opts={} )
    self.new( text, opts )
  end  


  def initialize( text, opts={} )
    @old_text = text
    @opts     = opts
  end


  ## change to DE_SCORES_REGEX or SCORES_DE_REGEX ??
  SCORES_REGEX = /\b
                  (?<score1>\d{1,2})
                    -
                  (?<score2>\d{1,2})
                  \b
                 /x

  def patch  ## return new text (and change log??)
    new_text = ''
    change_log = []   ## track changes  - rename - use edits? changes? etc.
    line_no = 0

    @old_text.each_line do |line|
      line_no +=1

      # comments allow:
      # 1) #####  (shell/ruby style)
      # 2) --  comment here (haskel/?? style)
      # 3) % comment here (tex/latex style)

      if line =~ /^\s*#/ || line =~ /^\s*--/ || line =~ /^\s*%/
        # skip komments and do NOT copy to result (keep comments secret!)
        logger.debug "[#{line_no}] add comment line >#{line}<"
        new_text << line
        next
      end

      if line =~ /^\s*$/ 
        # kommentar oder leerzeile überspringen 
        logger.debug "[#{line_no}] add blank line >#{line}<"
        new_text << line
        next
      end

      ## do nothing for now
      if line =~ SCORES_REGEX
        ## patch scores format
        logger.debug "** found scores >#{line}<"

        new_line = line.dup
        new_line.gsub!( SCORES_REGEX ) do |m|
          logger.debug " match: >#{m}<  : #{m.class.name}"

          old_scores = m
          ## todo: how to use named captures? possible?
          new_scores = "#{$1}:#{$2}"

          change_log << [line_no, "changed >#{old_scores}< to >#{new_scores}< in >#{line}<"]

          new_scores
        end

        logger.debug "[#{line_no}] add patched line >#{new_line}<"
        new_text << new_line
      else
        logger.debug "[#{line_no}] add >#{line}<"
        new_text << line
      end
    end # each lines

    [new_text, change_log]
  end # method patch


end # class PrettyPrinter
end # module SportDb
