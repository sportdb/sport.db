# encoding: UTF-8

module SportDb


###
## reads in a text files
##   and tries to fix up/patch some parts


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


  SCORES_REGEX = /\b
                  (?<score1>\d{1,2})
                    -
                  (?<score2>\d{1,2})
                  \b
                 /x

  def patch  ## return new text (and change log??)
    new_text = ''
    change_log = []   ## track changes  - rename - use edits? changes? etc.

    @old_text.each_line do |line|

      # comments allow:
      # 1) #####  (shell/ruby style)
      # 2) --  comment here (haskel/?? style)
      # 3) % comment here (tex/latex style)

      if line =~ /^\s*#/ || line =~ /^\s*--/ || line =~ /^\s*%/
        # skip komments and do NOT copy to result (keep comments secret!)
        logger.debug "add comment line >#{line}<"
        new_text << line
        next
      end

      if line =~ /^\s*$/ 
        # kommentar oder leerzeile überspringen 
        logger.debug "add blank line >#{line}<"
        new_text << line
        next
      end

      ## do nothing for now
      if line =~ SCORES_REGEX
        ## patch scores format
        logger.debug "** found scores >#{line}<"
        new_text << line
      else
        logger.debug "add >#{line}<"
        new_text << line
      end
    end # each lines

    [new_text, change_log]
  end # method patch


end # class PrettyPrinter
end # module SportDb
