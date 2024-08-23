
def test_duplicates
    club = Club.new
    club.name = 'Rapid Wien'

    assert_equal false, club.duplicates?
    duplicates = {}
    assert_equal duplicates,  club.duplicates

    club.alt_names_auto += ['Rapid', 'Rapid Wien', 'SK Rapid Wien']

    pp club

    assert_equal true,              club.duplicates?
    duplicates = {'rapidwien'=>['Rapid Wien','Rapid Wien']}
    pp club.duplicates
    assert_equal duplicates, club.duplicates
end

