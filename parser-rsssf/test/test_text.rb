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
    
   '   Bayer 04 Leverkusen   ' => 'Bayer 04 Leverkusen',
   '   TSG 1899 Hoffenheim  ' => 'TSG 1899 Hoffenheim',
   '   SV Darmstadt 98  ' => 'SV Darmstadt 98',
   '   Hannover 96   ' => 'Hannover 96',
   '   SC Paderborn 07  ' => 'SC Paderborn 07',
   '   FC Schalke 04 Gelsenkirchen  ' => 'FC Schalke 04 Gelsenkirchen',
   '   SV 07 Elversberg   ' => 'SV 07 Elversberg',
   '   SSV Ulm 1846   ' => 'SSV Ulm 1846',
   '   FC Ingolstadt 04  ' => 'FC Ingolstadt 04',
   '   TSV 1860 München  ' => 'TSV 1860 München',
   
   '   1.FC Heidenheim   ' => '1.FC Heidenheim',
   '   1.FSV Mainz 05   ' => '1.FSV Mainz 05',
   '   1.FC Union Berlin  ' => '1.FC Union Berlin',
   '   1.FC Köln     ' => '1.FC Köln',
   '   1.FC Nürnberg   ' => '1.FC Nürnberg',
   '   1.FC Kaiserslautern  ' => '1.FC Kaiserslautern',
   '   1.FC Magdeburg   ' => '1.FC Magdeburg',
   '   1.FC Saarbrücken  ' => '1.FC Saarbrücken',
   
   '   First Vienna FC 1894  ' => 'First Vienna FC 1894',
   '   Kapfenberger SV 1919  ' => 'Kapfenberger SV 1919',
   '   FC Dornbirn 1913   ' => 'FC Dornbirn 1913',
   '   Bischofshofener SK 1933  ' => 'Bischofshofener SK 1933',
   '   GAK 1902   ' => 'GAK 1902',
   '   FC Gleisdorf 09  ' => 'FC Gleisdorf 09',
   '   Gleisdorf 09 FC  ' => 'Gleisdorf 09 FC',
   
   '   SG Gneis/ASK-PSV Salzburg  ' => 'SG Gneis/ASK-PSV Salzburg',
   '   SV Unzmarkt-Frauenburg     ' => 'SV Unzmarkt-Frauenburg',
   '   FC Kindberg-Mürzhofen     ' => 'FC Kindberg-Mürzhofen',
   '   FC Blau-Weiß Feldkirch   ' => 'FC Blau-Weiß Feldkirch',
   '   Rot-Weiß Rankweil        ' => 'Rot-Weiß Rankweil',
   

   ## more names
   '  Centr.Afr. R.  ' => 'Centr.Afr. R.',
   '  Guinea-Bissau  ' => 'Guinea-Bissau',
   '  Congo-Kinshasa  ' => 'Congo-Kinshasa',
   '  Congo-Kinsh.  ' => 'Congo-Kinsh.',
   '  Cayman Isl.   ' => 'Cayman Isl.',
   '  Br. Virgin I.  ' => 'Br. Virgin I.',
   '  Dominican R.   ' => 'Dominican R.',
   '  Solomon I.   ' => 'Solomon I.',
   '  Papua New G.  ' => 'Papua New G.',
   '  Yokohama F. Marinos  ' => 'Yokohama F. Marinos',
   '  ASyD Justo J. de Urquiza  ' => 'ASyD Justo J. de Urquiza',
   '  CDyM Leandro N. Alem  ' => 'CDyM Leandro N. Alem',
   '  Club A. Sansinena Social y Deportivo  ' => 'Club A. Sansinena Social y Deportivo',
   '  SCR Peña D. Santa Eulalia  ' => 'SCR Peña D. Santa Eulalia',
   '  Shimizu S-Pulse   '  => 'Shimizu S-Pulse',     
   '  V-Varen Nagasaki   ' => 'V-Varen Nagasaki', 


   "  CA Newell's Old Boys   "  => "CA Newell's Old Boys", 
   "  CE L'Hospitalet  "        => "CE L'Hospitalet",
   



   ## text with and (&) AND trailing dot (.)
   '   Bosnia & Herz.   '           =>  'Bosnia & Herz.',
   '   São Tomé & Príncipe  '       =>  'São Tomé & Príncipe',
   '   Brighton & Hove Albion    '  =>  'Brighton & Hove Albion',
   '   Dagenham & Redbridge   '     =>  'Dagenham & Redbridge',
   '   Havant & Waterlooville   '   =>  'Havant & Waterlooville',
   '   Hayes & Yeading   '          =>  'Hayes & Yeading',
   

   ## text with slash
   '  Athletico/PR    '  =>  'Athletico/PR',    
   '  Atlético/GO     '  =>  'Atlético/GO', 
   '  Atlético/MG     '  =>  'Atlético/MG',  
   '  Antigua/Barb.   '  =>  'Antigua/Barb.',
   '  St.Vincent/G.   '  =>  'St.Vincent/G.',
   '  Turks/Caicos   '  =>  'Turks/Caicos',
   '  St. Kitts/N.   '  =>  'St. Kitts/N.',
   '  Trinidad/T.   '  =>  'Trinidad/T.',
 
   

   ## text with trainling ()
   '  Athletic Club (Bilbao)   ' =>  'Athletic Club (Bilbao)',
   '  USC Paloma (Hamburg)   '   =>  'USC Paloma (Hamburg)',
   '   SD Leioa (Lejona)   '  =>  'SD Leioa (Lejona)',
   '  CD Izarra (Estella)  '  =>  'CD Izarra (Estella)',
   

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

  