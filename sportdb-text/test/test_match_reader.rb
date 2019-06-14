# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_match_reader.rb


require 'helper'

class TestMatchReader < MiniTest::Test


##
# Div,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR,
#   Referee,HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,
#    B365H,B365D,B365A,BWH,BWD,BWA,IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,
#    WHH,WHD,WHA,VCH,VCD,VCA,
#    Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,
#    BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA,PSCH,PSCD,PSCA
  def test_eng_filters
    path = "#{SportDb::Import.test_data_dir}/eng-england/2017-18/E0.csv"

    matches = CsvMatchReader.read( path, filters: { 'HomeTeam' => 'Arsenal' } )

    pp path
    pp matches[0..2]

    m=matches[0]
    assert_equal '2017-08-11', m.date
    assert_equal 4, m.score1
    assert_equal 3, m.score2
    assert_equal 2, m.score1i
    assert_equal 2, m.score2i
    assert_equal 'Arsenal FC',        m.team1
    assert_equal 'Leicester City FC', m.team2

    m=matches[1]
    assert_equal '2017-09-09', m.date
    assert_equal 3, m.score1
    assert_equal 0, m.score2
    assert_equal 2, m.score1i
    assert_equal 0, m.score2i
    assert_equal 'Arsenal FC',      m.team1
    assert_equal 'AFC Bournemouth', m.team2
  end


  def test_eng_headers
    path = "#{SportDb::Import.test_data_dir}/eng-england/2017-18/E0.csv"

    headers = { team1:  'HomeTeam',
                team2:  'AwayTeam',
                date:   'Date',
                score1: 'FTHG',
                score2: 'FTAG' }

    matches = CsvMatchReader.read( path, headers: headers )

    pp path
    pp matches[0..2]

    m=matches[0]
    assert_equal '2017-08-11', m.date
    assert_equal 4, m.score1
    assert_equal 3, m.score2
    assert_nil   m.score1i      ## todo/fix: missing half time (ht) score !!!!
    assert_nil   m.score2i      ## todo/fix: missing half time (ht) score !!!!
    assert_equal 'Arsenal FC',        m.team1
    assert_equal 'Leicester City FC', m.team2

    m=matches[1]
    assert_equal '2017-08-12', m.date
    assert_equal 0, m.score1
    assert_equal 2, m.score2
    assert_nil   m.score1i      ## todo/fix: missing half time (ht) score !!!!
    assert_nil   m.score2i      ## todo/fix: missing half time (ht) score !!!!
    assert_equal 'Brighton & Hove Albion FC', m.team1
    assert_equal 'Manchester City FC',        m.team2
  end


###
# Country,League,Season,Date,Time,Home,Away,HG,AG,
#  Res,PH,PD,PA,MaxH,MaxD,MaxA,AvgH,AvgD,AvgA
  def test_at
    path = "#{SportDb::Import.test_data_dir}/at-austria/AUT.csv"

    matches = CsvMatchReader.read( path, filters: { 'Season' => '2017/2018' } )

    pp matches[0..2]
    pp path

    m=matches[0]
    assert_equal '2017-07-22', m.date
    assert_equal 2, m.score1
    assert_equal 2, m.score2
    assert_nil      m.score1i  ## todo/fix: missing half time (ht) score !!!!
    assert_nil      m.score2i  ## todo/fix: missing half time (ht) score !!!!
    assert_equal 'SK Rapid Wien',  m.team1
    assert_equal 'SV Mattersburg', m.team2

    m=matches[1]
    assert_equal '2017-07-22', m.date
    assert_equal 0, m.score1
    assert_equal 2, m.score2
    assert_nil   m.score1i    ## todo/fix: missing half time (ht) score !!!!
    assert_nil   m.score2i    ## todo/fix: missing half time (ht) score !!!!
    assert_equal 'Wolfsberger AC', m.team1
    assert_equal 'FC RB Salzburg', m.team2
  end


end # class TestMatchReader
