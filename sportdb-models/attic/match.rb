
############# convenience helpers for styling
##

def team1_style_class
  buf = ''
  ## NB: remove if calc?

  ### fix: loser
  ## - add method for checking winner/loser on ko pairs using (1st leg/2nd leg totals) ??
  ## use new winner_total method ??

  if complete?
    if winner1?
      buf << 'match-team-winner '
    elsif winner2?
      buf << 'match-team-loser '
    else # assume draw
      buf << 'match-team-draw '
    end
  end

  buf << 'match-knockout '     if knockout?
  buf
end

def team2_style_class
  buf = ''
  ## NB: remove if calc?

  ### fix: loser
  ## - add method for checking winner/loser on ko pairs using (1st leg/2nd leg totals) ??
  ## use new winner_total method ??

  if complete?
    if winner1?
      buf << 'match-team-loser '
    elsif winner2?
      buf << 'match-team-winner '
    else # assume draw
      buf << 'match-team-draw '
    end
  end

  buf << 'match-knockout '     if knockout?
  buf
end
