###
#  to run use
#     ruby -I . test_csv_match_parser.rb


require 'helper'


class TestCsvMatchParser < MiniTest::Test

##
# Div,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR,
#   Referee,HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,
#    B365H,B365D,B365A,BWH,BWD,BWA,IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,
#    WHH,WHD,WHA,VCH,VCD,VCA,
#    Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,
#    BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA,PSCH,PSCD,PSCA
  def test_eng_filters
    path = "#{SportDb::Test.data_dir}/england/2017-18/E0.csv"

    matches = SportDb::CsvMatchParser.read( path,
                                            filters: { 'HomeTeam' => 'Arsenal' } )

    pp path
    pp matches[0..2]

    m=matches[0]
    assert_equal '2017-08-11', m.date
    assert_equal 4, m.score1
    assert_equal 3, m.score2
    assert_equal 2, m.score1i
    assert_equal 2, m.score2i
    assert_equal 'Arsenal',    m.team1
    assert_equal 'Leicester',  m.team2

    m=matches[1]
    assert_equal '2017-09-09', m.date
    assert_equal 3, m.score1
    assert_equal 0, m.score2
    assert_equal 2, m.score1i
    assert_equal 0, m.score2i
    assert_equal 'Arsenal',     m.team1
    assert_equal 'Bournemouth', m.team2
  end


  def test_eng_headers
    path = "#{SportDb::Test.data_dir}/england/2017-18/E0.csv"

    headers = { team1:  'HomeTeam',
                team2:  'AwayTeam',
                date:   'Date',
                score1: 'FTHG',
                score2: 'FTAG' }

    matches = SportDb::CsvMatchParser.read( path, headers: headers )

    pp path
    pp matches[0..2]

    m=matches[0]
    assert_equal '2017-08-11', m.date
    assert_equal 4, m.score1
    assert_equal 3, m.score2
    assert_nil   m.score1i      ## todo/fix: missing half time (ht) score !!!!
    assert_nil   m.score2i      ## todo/fix: missing half time (ht) score !!!!
    assert_equal 'Arsenal',   m.team1
    assert_equal 'Leicester', m.team2

    m=matches[1]
    assert_equal '2017-08-12', m.date
    assert_equal 0, m.score1
    assert_equal 2, m.score2
    assert_nil   m.score1i      ## todo/fix: missing half time (ht) score !!!!
    assert_nil   m.score2i      ## todo/fix: missing half time (ht) score !!!!
    assert_equal 'Brighton', m.team1
    assert_equal 'Man City', m.team2
  end


###
# Country,League,Season,Date,Time,Home,Away,HG,AG,
#  Res,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA
  def test_at
    path = "#{SportDb::Test.data_dir}/austria/AUT.csv"

    matches = SportDb::CsvMatchParser.read( path, filters: { 'Season' => '2017/2018' } )

    pp matches[0..2]
    pp path

    m=matches[0]
    assert_equal '2017-07-22', m.date
    assert_equal 2, m.score1
    assert_equal 2, m.score2
    assert_nil      m.score1i  ## todo/fix: missing half time (ht) score !!!!
    assert_nil      m.score2i  ## todo/fix: missing half time (ht) score !!!!
    assert_equal 'Rapid Vienna', m.team1
    assert_equal 'Mattersburg',  m.team2

    m=matches[1]
    assert_equal '2017-07-22', m.date
    assert_equal 0, m.score1
    assert_equal 2, m.score2
    assert_nil   m.score1i    ## todo/fix: missing half time (ht) score !!!!
    assert_nil   m.score2i    ## todo/fix: missing half time (ht) score !!!!
    assert_equal 'AC Wolfsberger', m.team1
    assert_equal 'Salzburg',       m.team2
  end


end # class TestCsvMatchParser
