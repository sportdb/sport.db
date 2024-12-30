###
#  to run use
#     ruby test/test_countries.rb


require_relative 'helper'

class TestCountries < Minitest::Test

  def test_read_countries
    recs = Fifa::CountryReader.read( "#{Fifa.data_dir}/africa.txt" )
    ## pp recs

    assert_equal [{ key: 'bi', code: 'BDI', name: 'Burundi',   tags: ['fifa','caf','cecafa']},
                  { key: 'dj', code: 'DJI', name: 'Djibouti', tags: ['fifa','caf','cecafa']}],
                 recs[0..1].map { |rec| { key: rec.key, code: rec.code, name: rec.name, tags: rec.tags }}
  end


  def test_eng
    pp Fifa.world.countries

    eng = Fifa['ENG']
    assert_equal eng, Fifa['eng']
    assert_equal eng, Fifa[:eng]

    assert_equal 'eng',           eng.key
    assert_equal 'England',       eng.name
    assert_equal 'ENG',           eng.code
    assert_equal ['fifa','uefa'], eng.tags

    ## new - test codes & names (virtual) helpers
    assert_equal ['eng', 'en'], eng.codes
    assert_equal ['England'],   eng.names
    assert_equal 'English',     eng.adj
    assert_equal ['English'],   eng.adjs

    assert_equal eng, Fifa['EN']
    assert_equal eng, Fifa[:en]
  end

  def test_aut
    aut  = Fifa['AUT']
    assert_equal aut, Fifa['aut']
    assert_equal aut, Fifa[:aut]

    assert_equal 'at',            aut.key
    assert_equal 'Austria',       aut.name
    assert_equal 'AUT',           aut.code
    assert_equal ['fifa','uefa'], aut.tags

    ## new - test codes & names (virtual) helpers
    assert_equal ['at', 'aut', 'a', 'ö'],   aut.codes
    assert_equal ['Austria', 'Österreich'], aut.names
    assert_equal 'Österr.',                 aut.adj
    assert_equal ['Österr.', 'Austrian'],   aut.adjs

    assert_equal aut, Fifa['AT']
    assert_equal aut, Fifa[:at]
    assert_equal aut, Fifa['A']
    assert_equal aut, Fifa['ö']
    assert_equal aut, Fifa['Ö']
  end

  def test_kos
    #  kos - Kosovo (KOS)|kvx|xk
    kos  = Fifa['KOS']
    assert_equal kos, Fifa['kos']
    assert_equal kos, Fifa[:kos]

    assert_equal 'kos',           kos.key
    assert_equal 'Kosovo',        kos.name
    assert_equal 'KOS',           kos.code
    assert_equal ['fifa','uefa'], kos.tags

    ## new - test codes & names (virtual) helpers
    assert_equal ['kos', 'kvx', 'xk'],   kos.codes
    assert_equal ['Kosovo'], kos.names

    assert_equal kos, Fifa['XK']
    assert_equal kos, Fifa[:xk]
    assert_equal kos, Fifa['KVX']
  end

  def test_usa
    usa  = Fifa['USA']
    assert_equal usa, Fifa['usa']
    assert_equal usa, Fifa[:usa]

    assert_equal 'us',            usa.key
    assert_equal 'United States', usa.name
    assert_equal 'USA',           usa.code
    assert_equal ['fifa','concacaf', 'nafu'], usa.tags

    ## new - test codes & names (virtual) helpers
    assert_equal ['us', 'usa'],            usa.codes
    assert_equal ['United States', 'US', 'USA'], usa.names

    assert_equal usa, Fifa['us']
    assert_equal usa, Fifa[:us]
  end
end # class TestCountries
