###
#  to run use
#     ruby test/test_orgs.rb


require_relative 'helper'

class TestOrgs < Minitest::Test

  def test_orgs
    ## print counts
    puts "#{'%3d' % Fifa.world.size} countries:"
    Fifa.world.orgs.each do |org|
      countries = Fifa.members( org )
      puts "#{'%3d' % countries.size} #{org}"
    end

    ## pp Fifa.members( 'OFC' ).sort_by {|rec| rec.name }

    assert_equal  47, Fifa.members( 'AFC' ).size       # => Asian Football Confederation
    assert_equal  56, Fifa.members( 'CAF' ).size       # => Confédération Africaine de Football
    assert_equal  41, Fifa.members( 'CONCACAF' ).size  # => Confederation of North, Central American and Caribbean Association Football
    assert_equal  10, Fifa.members( 'CONMEBOL' ).size  # => Confederación Sudamericana de Fútbol
    assert_equal  14, Fifa.members( 'OFC' ).size       # => Oceania Football Confederation
    assert_equal  55, Fifa.members( 'UEFA' ).size      # => Union of European Football Associations

    assert_equal   3, Fifa.members( 'NAFU' ).size      # => North American Football Union
    assert_equal   7, Fifa.members( 'UNCAF' ).size     # => Unión Centroamericana de Fútbol
    assert_equal  31, Fifa.members( 'CFU' ).size       # => Caribbean Football Union

    assert_equal  12, Fifa.members( 'WAFF' ).size      # => West Asian Football Federation
    assert_equal  10, Fifa.members( 'EAFF' ).size      # => East Asian Football Federation
    assert_equal   6, Fifa.members( 'CAFA' ).size      # => Central Asian Football Association
    assert_equal   7, Fifa.members( 'SAFF' ).size      # => South Asian Football Federation
    assert_equal  12, Fifa.members( 'AFF' ).size       # => ASEAN Football Federation

    assert_equal  12, Fifa.members( 'CECAFA' ).size    # => Council for East and Central Africa Football Associations
    assert_equal  14, Fifa.members( 'COSAFA' ).size    # => Council of Southern Africa Football Associations
    assert_equal  16, Fifa.members( 'WAFU' ).size      # => West African Football Union/Union du Football de l'Ouest Afrique
    assert_equal   5, Fifa.members( 'UNAF' ).size      # => Union of North African Federations
    assert_equal   8, Fifa.members( 'UNIFFAC' ).size   # => Union des Fédérations du Football de l'Afrique Centrale

    assert_equal 211, Fifa.members( 'FIFA' ).size


    ## print countries NOT members of fifa (but of confederation)
    puts "non-fifa member codes:"
    Fifa.world.each do |country|
      if country.tags.empty? == false &&
         country.tags.include?( 'fifa' ) == false
        puts "  #{country.name}, #{country.code}, #{country.tags.join(' | ')}"
      end
    end

    ## print countries NOT members of fifa or any confederation (irregular codes)
    puts "irregular codes:"
    Fifa.world.each do |country|
      puts "  #{country.name}, #{country.code}"    if country.tags.empty?
    end
  end



    def _norm_org( name )
      ## todo/fix:  use version from OrgIndex !!!!
      ## remove space, comma, ampersand (&) and words: and, the
      name.gsub( /  [ ,&] |
                   \band\b |
                   \bthe\b
                 /x, '' )
    end


  def test_alt_names
    ## check normalize org key / name
    assert_equal 'NorthAmericaCentralAmericaCaribbean', _norm_org( 'North America, Central America and the Caribbean' )
    assert_equal 'NorthCentralAmericaCaribbean', _norm_org( 'North and Central America and the Caribbean' )
    assert_equal 'NorthCentralAmericaCaribbean', _norm_org( 'North & Central America & Caribbean' )


    assert_equal Fifa.members( 'FIFA' ).size,     Fifa.members( 'World' ).size
    assert_equal Fifa.members( 'UEFA' ).size,     Fifa.members( 'Europe' ).size
    assert_equal Fifa.members( 'CAF' ).size,      Fifa.members( 'Africa' ).size
    assert_equal Fifa.members( 'CECAFA' ).size,   Fifa.members( 'East and Central Africa' ).size
    assert_equal Fifa.members( 'COSAFA' ).size,   Fifa.members( 'Southern Africa' ).size
    assert_equal Fifa.members( 'WAFU' ).size,     Fifa.members( 'West Africa' ).size
    assert_equal Fifa.members( 'UNAF' ).size,     Fifa.members( 'North Africa' ).size
    assert_equal Fifa.members( 'UNIFFAC' ).size,  Fifa.members( 'Central Africa' ).size
    assert_equal Fifa.members( 'CONCACAF' ).size, Fifa.members( 'North America, Central America and the Caribbean' ).size
    assert_equal Fifa.members( 'CONCACAF' ).size, Fifa.members( 'North and Central America and the Caribbean' ).size
    assert_equal Fifa.members( 'CONCACAF' ).size, Fifa.members( 'North & Central America & Caribbean' ).size
    assert_equal Fifa.members( 'NAFU' ).size,     Fifa.members( 'North America' ).size
    assert_equal Fifa.members( 'UNCAF' ).size,    Fifa.members( 'Central America' ).size
    assert_equal Fifa.members( 'CFU' ).size,      Fifa.members( 'Caribbean' ).size
    assert_equal Fifa.members( 'CONMEBOL' ).size, Fifa.members( 'South America' ).size
    assert_equal Fifa.members( 'AFC' ).size,      Fifa.members( 'Asia' ).size
    assert_equal Fifa.members( 'WAFF' ).size,     Fifa.members( 'Middle East' ).size
    assert_equal Fifa.members( 'EAFF' ).size,     Fifa.members( 'East Asia' ).size
    assert_equal Fifa.members( 'CAFA' ).size,     Fifa.members( 'Central Asia' ).size
    assert_equal Fifa.members( 'SAFF' ).size,     Fifa.members( 'South Asia' ).size
    assert_equal Fifa.members( 'AFF' ).size,      Fifa.members( 'Southeast Asia' ).size
    assert_equal Fifa.members( 'OFC' ).size,      Fifa.members( 'Oceania' ).size
    assert_equal Fifa.members( 'OFC' ).size,      Fifa.members( 'Pacific' ).size
  end
end # class TestOrgs
