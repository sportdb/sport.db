###
#  to run use
#     ruby test/test_text.rb


require_relative 'helper'




class TestText < Minitest::Test

def test_text

 lines = {
    ## text with numbers
   '   SSV Ulm 1846       '   => 'SSV Ulm 1846',
   '    FC Ingolstadt 04   '  => 'FC Ingolstadt 04',
   '    TSV 1860 München  '   => 'TSV 1860 München',
    
   '    1.FC Heidenheim     '   => '1.FC Heidenheim',
   '    1.FSV Mainz 05      '   => '1.FSV Mainz 05',
   '    1.FC Union Berlin   '   => '1.FC Union Berlin',
   '    1. FC Heidenheim     '   => '1. FC Heidenheim',
   '    1. FSV Mainz 05      '   => '1. FSV Mainz 05',
   '    1. FC Union Berlin   '   => '1. FC Union Berlin',
    
   ## text with and (&) AND trailing dot (.)
   '   Bosnia & Herz.   '  =>  'Bosnia & Herz.',

   ## text with slash
   '   Atlético/PR    '  =>  'Atlético/PR',
   '  Atlético/MG     '  =>  'Atlético/MG',  
 
   ## team (with score)
  '   Atlas 2-1 Pumas   '   => 'Atlas',
  '   Puebla 1-1 Morelia   '  => 'Puebla',

    ## rounds (with numbers)
   ' Round 2   '             =>  'Round 2',
   'Round 2'                 =>  'Round 2',
 
   ## players (with numbers)
   ##  note - must switch to strict mode
   ##            if you do NOT want to include numbers!!!
   '  Abraham González 1  '  =>  'Abraham González 1',
   '   Brayan Angulo 45og  '  =>  'Brayan Angulo 45og', 

 }


  lines.each do |line,exp|
    m = TEXT_RE.match( line )
    pp m
    pp m[:text]
    pp m.named_captures

    assert_equal exp, m[:text]
  end
end

end # class TestText

  