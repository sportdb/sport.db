
def test_read_csv
  recs = read_csv( "#{SportDb::Test.data_dir}/world/countries.txt" )
  ## pp recs

  assert_equal  [{ key:'af', fifa:'AFG', name:'Afghanistan'},
                 { key:'al', fifa:'ALB', name:'Albania'},
                 { key:'dz', fifa:'ALG', name:'Algeria'},
                 { key:'as', fifa:'ASA', name:'American Samoa (US)'},
                ], recs[0..3]
end
