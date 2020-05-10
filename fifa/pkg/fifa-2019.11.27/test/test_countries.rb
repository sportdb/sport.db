# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_countries.rb


require 'helper'

class TestCountries < MiniTest::Test

  def test_read_countries
    recs = SportDb::Import::CountryReader.read( "#{Fifa.data_dir}/countries.txt" )
    ## pp recs

    assert_equal [{ key: 'al', fifa: 'ALB', name: 'Albania', tags: ['fifa','uefa']},
                  { key: 'ad', fifa: 'AND', name: 'Andorra', tags: ['fifa','uefa']}],
                 recs[0..1].map { |rec| { key: rec.key, fifa: rec.fifa, name: rec.name, tags: rec.tags }}
  end


  def test_countries
    pp Fifa.countries

    eng = Fifa['ENG']
    assert_equal eng, Fifa['eng']
    assert_equal eng, Fifa[:eng]

    assert_equal 'eng',           eng.key
    assert_equal 'England',       eng.name
    assert_equal 'ENG',           eng.fifa
    assert_equal ['fifa','uefa'], eng.tags

    assert_equal 'eng',           eng[:key]
    assert_equal 'England',       eng[:name]
    assert_equal 'ENG',           eng[:fifa]


    aut  = Fifa['AUT']
    assert_equal aut, Fifa['aut']
    assert_equal aut, Fifa[:aut]

    assert_equal 'at',            aut.key
    assert_equal 'Austria',       aut.name
    assert_equal 'AUT',           aut.fifa
    assert_equal ['fifa','uefa'], aut.tags

    assert_equal 'at',            aut[:key]
    assert_equal 'Austria',       aut[:name]
    assert_equal 'AUT',           aut[:fifa]
  end

end # class TestCountries
