class Score

  def to_formatted_s( format=:default, lang: ScoreFormats.lang )
    ## note: format gets ignored for now (only one available)
    case lang.to_sym
    when :de   then   format_de( format )
    else              format_en( format ) # note: for now always fallback to english
    end
  end
  alias_method :to_s, :to_formatted_s



  def format_en( format=:default )
    ## note: format gets ignored for now (only one available)

    buf = String.new
    ## note:  allow (minimal) scores only with a.e.t. (and no full time)
    ###       allow (minimal) score only with pen. too
    if ft? || et? || p?
      if p?
        buf << "#{@score1p}-#{@score2p} pen."
      end
      if et?
        buf << " #{@score1et}-#{@score2et} a.e.t."
      end
      if ft?
         if buf.empty?
           buf << " #{@score1}-#{@score2}"
           ## note:
           ##   avoid 0-0 (0-0)
           ##  only print if score1 & score2 NOT 0-0
           if ht? && ft != [0,0]
             buf << " (#{@score1i}-#{@score2i})"
           end
         else  ## assume pen. and/or a.e.t.
           buf << " (#{@score1}-#{@score2}"
           if ht? && ft != [0,0]
             buf << ", #{@score1i}-#{@score2i}"
           end
           buf << ")"
         end
      end
    else # assume empty / unknown score
       buf << '-'
    end
    buf.strip
  end


  def format_de( format=:default )
    ## note: format gets ignored for now (only one available)

    buf = String.new('')
    ## note: also allow (minimal) scores only with a.e.t. (and no full time)
    if ft? || et?        # 2-2 (1-1) n.V. 5-1 i.E.
      if et?
        buf << "#{@score1et}:#{@score2et}"
      end
      if ft?
        if buf.empty?
          buf << " #{@score1}:#{@score2}"
          ## note:
          ##   avoid 0-0 (0-0)
          ##  only print if score1 & score2 NOT 0-0
          if ht? && ft != [0,0]
            buf << " (#{@score1i}:#{@score2i})"
          end
        else  ## assume pen. and/or a.e.t.
          buf << " (#{@score1}:#{@score2}"
          if ht? && ft != [0,0]
            buf << ", #{@score1i}:#{@score2i}"
          end
          buf << ")"
        end
      end
      if et?
        buf << " n.V."
      end
      if p?
        buf << " #{@score1p}:#{@score2p} i.E."
      end
    else # assume empty / unknown score
      buf << '-'
    end
    buf.strip
  end


end # class Score
