###
#  to run use
#     ruby test/test_goals.rb


require_relative 'helper'




class TestGoals < Minitest::Test


  def test_text_strict
    lines = {
        %Q{"Renato" Dirnei Florencio 87   }       => %Q{"Renato" Dirnei Florencio},  
        %Q{"Simao" Pedro Fonseca 90    }          => %Q{"Simao" Pedro Fonseca},  
        %Q{   "Nilmar" Honorato da Silva 77     } => %Q{"Nilmar" Honorato da Silva},  
        %Q{   "Tiago" Cardoso Mendes 80     }     => %Q{"Tiago" Cardoso Mendes},  
        %Q{  "Cristiano Ronaldo" dos Santos Aveiro 74    } => %Q{"Cristiano Ronaldo" dos Santos Aveiro},  
        %Q{     "Zé Castro" José Eduardo Rosa Vale Castro 60og  } => %Q{"Zé Castro" José Eduardo Rosa Vale Castro},
        %Q{     Antonio Galdeano "Apoño" 61pen  } => %Q{Antonio Galdeano "Apoño"},
        %Q{     Xavier "Xavi" Hernández 73   } => %Q{Xavier "Xavi" Hernández},
        ## for more see https://github.com/rsssf/espana/blob/master/2010-11/1-liga.txt
    }
  
    lines.each do |line,exp|
      puts "==> >#{line}<"
      m = TEXT_STRICT_RE.match( line )
      pp m
      pp m[:text]
      pp m.named_captures
  
      assert_equal exp, m[:text]
    end
  end
  
  

def test_og
  lines = {
    '   Brayan Angulo 45og  '  =>  'og', 
    '   Brayan Angulo 45 og  '  =>  'og', 
    '   45og  '                =>  'og', 
    '   Brayan Angulo 45+og  '  =>  'og', 
    '   Brayan Angulo 45+ og  '  =>  'og', 
    "   Brayan Angulo 45'og  "  =>  'og', 
    "   Brayan Angulo 45' og  "  =>  'og', 
    "   45'og  "                =>  'og', 
    "   Brayan Angulo 45'+og  "  =>  'og', 
    "   Brayan Angulo 45'+ og  "  =>  'og', 
  }

  lines.each do |line,exp|
    puts "==> >#{line}<"
    m = GOAL_OG_RE.match( line )
    pp m
    pp m[:og]
    pp m.named_captures

    assert_equal exp, m[:og]
  end
end

def test_pen
  lines = {
'  Rafael Sóbis 15p  '  => 'p',
'  Rafael Sóbis 15pen  '  => 'pen',
'  Rafael Sóbis 15 pen  '  => 'pen',
'  Rafael Sóbis 15 p  '  => 'p',
 '  Rafael Sóbis 45+p  '  => 'p',
 '  Rafael Sóbis 45+pen  '  => 'pen',
 '  Rafael Sóbis 45+ p  '  => 'p',
 '  Rafael Sóbis 45+ pen  '  => 'pen',
 "  Rafael Sóbis 15' pen  "  => 'pen',
 "  Rafael Sóbis 15' p  "  => 'p',
 "  Rafael Sóbis 45'+p  "  => 'p',
 "  Rafael Sóbis 45'+pen  "  => 'pen',
}

lines.each do |line,exp|
  puts "==> >#{line}<"
  m = GOAL_PEN_RE.match( line )
  pp m
  pp m[:pen]
  pp m.named_captures

  assert_equal exp, m[:pen]
end
end



def test_minutes

  lines = {
      '   Jô   48    '        =>   '48',
      '48'                    =>   '48',      
      '  Abraham González 1  '  =>  '1',
      '  1  '                   =>  '1',
      '   Brayan Angulo 45og  '  =>  '45', 
      '   Brayan Angulo 45 og  '  =>  '45', 
      '   45og  '                =>  '45', 
      '  Rafael Sóbis 15p  '  => '15',
      '  Rafael Sóbis 15pen  '  => '15',
      '  Rafael Sóbis 15 pen  '  => '15',
      '  Rafael Sóbis 15 p  '  => '15',
      ## with offset
      '   Matheus Ferraz 45+1   ' => '45+1',
       '  Arthur 90+1  '       => '90+1',
       '  Caio 90+10  '        => '90+10',
       '   Matheus Ferraz 45+   ' => '45+',
       '  Arthur 90+  '       => '90+',
       '  Caio 90+  '        => '90+',
       '   Brayan Angulo 45+og  '  =>  '45+', 
       '   Brayan Angulo 45+ og  '  =>  '45+', 
       '   45+og  '                =>  '45+', 
       '  Rafael Sóbis 45+p  '  => '45+',
       '  Rafael Sóbis 45+pen  '  => '45+',
       '  Rafael Sóbis 45+ p  '  => '45+',
       '  Rafael Sóbis 45+ pen  '  => '45+',

       ### with (optional) minute tag
           "   Jô   48'    "        =>   "48'",
           "48'"                    =>   "48'",      
         "  Abraham González 1'  "  =>  "1'",
         "  1'  "                   =>  "1'",
         "   Brayan Angulo 45'og  "  =>  "45'", 
         "   Brayan Angulo 45' og  "  =>  "45'", 
         "   45'og  "                =>  "45'", 
         "  Rafael Sóbis 15'p  "  => "15'",
         "  Rafael Sóbis 15'pen  "  => "15'",
         "  Rafael Sóbis 15' pen  "  => "15'",
         "  Rafael Sóbis 15' p  "  => "15'",
       }

  lines.each do |line,exp|
    puts "==> >#{line}<"
    m = MINUTE_RE.match( line )
    pp m
    pp m[:minute]
    pp m.named_captures

    assert_equal exp, m[:minute]
  end
end



def test_tokenize
  lines = {
  '  Rafael Sóbis 45+p  '  =>   [[:text, "Rafael Sóbis"], [:minute, "45+"], [:pen, "p"]],
  '  Rafael Sóbis 45+pen  '  => [[:text, "Rafael Sóbis"], [:minute, "45+"], [:pen, "pen"]],
  '  Rafael Sóbis 45+ p  '  =>  [[:text, "Rafael Sóbis"], [:minute, "45+"], [:pen, "p"]],
  '  Rafael Sóbis 45+ pen  '  => [[:text, "Rafael Sóbis"], [:minute, "45+"], [:pen, "pen"]],
  "  Rafael Sóbis 15' pen  "  => [[:text, "Rafael Sóbis"], [:minute, "15'"], [:pen, "pen"]],
  '   Jô   48    '        =>   [[:text, "Jô"], [:minute, "48"]],
  "   Jô   48'    "        =>   [[:text, "Jô"], [:minute, "48'"]],
  '  Abraham González 1  '  =>  [[:text, "Abraham González"], [:minute, "1"]],
  "  Abraham González 1'  "  =>  [[:text, "Abraham González"], [:minute, "1'"]],
  '   Brayan Angulo 45og  '  =>  [[:text, "Brayan Angulo"], [:minute, "45"], [:og, "og"]], 
  '   Brayan Angulo 45 og  '  =>  [[:text, "Brayan Angulo"], [:minute, "45"], [:og, "og"]], 
  "   Brayan Angulo 45'og  "  =>  [[:text, "Brayan Angulo"], [:minute, "45'"], [:og, "og"]], 
  "   Brayan Angulo 45' og  "  =>  [[:text, "Brayan Angulo"], [:minute, "45'"], [:og, "og"]], 
  '  Rafael Sóbis 15p  '  => [[:text, "Rafael Sóbis"], [:minute, "15"], [:pen, "p"]],
  '  Rafael Sóbis 15pen  '  => [[:text, "Rafael Sóbis"], [:minute, "15"], [:pen, "pen"]],
  '  Rafael Sóbis 15 pen  '  => [[:text, "Rafael Sóbis"], [:minute, "15"], [:pen, "pen"]],
  '  Rafael Sóbis 15 p  '  => [[:text, "Rafael Sóbis"], [:minute, "15"], [:pen, "p"]],
  '   Matheus Ferraz 45+1   ' => [[:text, "Matheus Ferraz"], [:minute, "45+1"]],
   '  Arthur 90+1  '       => [[:text, "Arthur"], [:minute, "90+1"]],
   '  Caio 90+10  '        => [[:text, "Caio"], [:minute, "90+10"]],
   '   Matheus Ferraz 45+   ' => [[:text, "Matheus Ferraz"], [:minute, "45+"]],

   %Q{   "Tiago" Cardoso Mendes 80     }     => [[:text, %Q{"Tiago" Cardoso Mendes}],
                                                  [:minute, "80"]],  
   %Q{  "Cristiano Ronaldo" dos Santos Aveiro 74    } => [[:text, %Q{"Cristiano Ronaldo" dos Santos Aveiro}],
                                                          [:minute, "74"]],  
   %Q{     "Zé Castro" José Eduardo Rosa Vale Castro 60og  } => [[:text, %Q{"Zé Castro" José Eduardo Rosa Vale Castro}],
                                                                 [:minute, "60"], [:og, "og"]],
   %Q{     Antonio Galdeano "Apoño" 61pen  } =>  [[:text, %Q{Antonio Galdeano "Apoño"}],
                                                  [:minute, "61"], [:pen, "pen"]],
   %Q{     Xavier "Xavi" Hernández 73   } =>   [[:text, %Q{Xavier "Xavi" Hernández}],
                                                 [:minute, "73"]],

   "Cardoso 84" => [[:text, "Cardoso"], [:minute, "84"]],

   ## try minutes first
  ## deutschland/2010-11/cup.txt
 ##  (18' Draxler, 22' Huntelaar, 42' Höwedes, 55' Jurado, 70' Huntelaar)
 "   18' Draxler      " => [[:minute, "18'"], [:text, "Draxler"]],
 "18' Draxler" => [[:minute, "18'"], [:text, "Draxler"]],
 "   18 Draxler  " => [[:minute, "18"], [:text, "Draxler"]],
 "18 Draxler"      => [[:minute, "18"], [:text, "Draxler"]],
 " 18' Draxler, 22' Huntelaar, 42' Höwedes  " => 
   [[:minute, "18'"],[:text, "Draxler"],[:","],
    [:minute, "22'"],[:text, "Huntelaar"],[:","],
    [:minute, "42'"],[:text, "Höwedes"]],
 "18' Draxler, 22' Huntelaar, 42' Höwedes" => 
   [[:minute, "18'"],[:text, "Draxler"],[:","],
    [:minute, "22'"],[:text, "Huntelaar"],[:","],
    [:minute, "42'"],[:text, "Höwedes"]],
 "18 Draxler, 22 Huntelaar, 42 Höwedes" => 
   [[:minute, "18"],[:text, "Draxler"],[:","],
    [:minute, "22"],[:text, "Huntelaar"],[:","],
    [:minute, "42"],[:text, "Höwedes"]],
  }
 
  ## note - wrap line in [] for "inside" mode!!!!
  lines.each do |line,exp|
    puts "==> >#{line}<"
    t = tokenize( "[#{line}]" )
    pp t
    assert_equal exp, t

    ## try again with () too
    t = tokenize( "(#{line})" )
    pp t
    assert_equal exp, t
  end
end

end # class TestGoals

  