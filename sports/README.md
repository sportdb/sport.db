# sports - sport data structures for matches, scores, leagues, seasons, rounds, groups, teams, clubs and more


* home  :: [github.com/sportdb/sport.db](https://github.com/sportdb/sport.db)
* bugs  :: [github.com/sportdb/sport.db/issues](https://github.com/sportdb/sport.db/issues)
* gem   :: [rubygems.org/gems/sports](https://rubygems.org/gems/sports)
* rdoc  :: [rubydoc.info/gems/sports](http://rubydoc.info/gems/sports)
* forum :: [opensport](http://groups.google.com/group/opensport)



## Usage


### Working with CSV Datafiles

Let's build the standings table for the English Premier League (EPL) for the 2019/20 season from all matches
in the comma-separated values (.csv) format.
Example:

```
                                        - Home -          - Away -            - Total -
                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts
 1. Liverpool FC                  38  18  1  0  52:16   14  2  3  33:17    85:33  +52   99
 2. Manchester City FC            38  15  2  2  57:13   11  1  7  45:22   102:35  +67   81
 3. Manchester United FC          38  10  7  2  40:17    8  5  6  26:19    66:36  +30   66
 4. Chelsea FC                    38  11  3  5  30:16    9  3  7  39:38    69:54  +15   66
 5. Leicester City FC             38  11  4  4  35:17    7  4  8  32:24    67:41  +26   62
 6. Tottenham Hotspur FC          38  12  3  4  36:17    4  8  7  25:30    61:47  +14   59
 7. Wolverhampton Wanderers FC    38   8  7  4  27:19    7  7  5  24:21    51:40  +11   59
 8. Arsenal FC                    38  10  6  3  36:24    4  8  7  20:24    56:48   +8   56
 9. Sheffield United FC           38  10  3  6  24:15    4  9  6  15:24    39:39        54
10. Burnley FC                    38   8  4  7  24:23    7  5  7  19:27    43:50   -7   54
11. Southampton FC                38   6  3 10  21:35    9  4  6  30:25    51:60   -9   52
12. Everton FC                    38   8  7  4  24:21    5  3 11  20:35    44:56  -12   49
13. Newcastle United FC           38   6  8  5  20:21    5  3 11  18:37    38:58  -20   44
14. Crystal Palace FC             38   6  5  8  15:20    5  5  9  16:30    31:50  -19   43
15. Brighton & Hove Albion FC     38   5  7  7  20:27    4  7  8  19:27    39:54  -15   41
16. West Ham United FC            38   6  4  9  30:33    4  5 10  19:29    49:62  -13   39
17. Aston Villa FC                38   7  3  9  22:30    2  5 12  19:37    41:67  -26   35
18. AFC Bournemouth               38   5  6  8  22:30    4  1 14  18:35    40:65  -25   34
19. Watford FC                    38   6  6  7  22:27    2  4 13  14:37    36:64  -28   34
20. Norwich City FC               38   4  3 12  19:37    1  3 15   7:38    26:75  -49   21
```


Step 0: Download the free public domain [`/england`](https://github.com/footballcsv/england) dataset package / archive from the [football.csv org](https://footballcsv.github.io).

What's the comma-separated values (.csv) format?
It's the world's most popular tabular data interchange format in text.
Values are separated - surprise, surprise - by commas (that is, `,`).
One line is one record, that is, one match :-).
Example:

```
Team 1,               FT,  HT,  Team 2
Liverpool FC,         4-1, 4-0, Norwich City FC
West Ham United FC,   0-5, 0-1, Manchester City FC
AFC Bournemouth,      1-1, 0-0, Sheffield United FC
Burnley FC,           3-0, 0-0, Southampton FC
Crystal Palace FC,    0-0, 0-0, Everton FC
Watford FC,           0-3, 0-1, Brighton & Hove Albion FC
Tottenham Hotspur FC, 3-1, 0-1, Aston Villa FC
Leicester City FC,    0-0, 0-0, Wolverhampton Wanderers FC
Newcastle United FC,  0-1, 0-0, Arsenal FC
Manchester United FC, 4-0, 1-0, Chelsea FC
...
```

Let's use the [`eng.1.csv`](https://github.com/footballcsv/england/blob/master/2010s/2019-20/eng.1.csv), that is, the English Premier League datafile in the `/2010s/2019-20` folder.
Read in all matches with the `Match.read_csv` method from the sports library / gem:


``` ruby
require 'sports'

include Sports     ## include Match, Team, Standings, etc. data classes


matches = Match.read_csv( 'england/2010s/2019-20/eng.1.csv' )
pp matches.size  #=> 380
pp matches
```

will pretty print (pp):

```
[#<Sports::Match
  @date="2019-08-09",
  @score1=4,
  @score1i=4,
  @score2=1,
  @score2i=0,
  @team1="Liverpool FC",
  @team2="Norwich City FC",
  @winner=1>,
 #<Sports::Match
  @date="2019-08-10",
  @score1=0,
  @score1i=0,
  @score2=5,
  @score2i=1,
  @team1="West Ham United FC",
  @team2="Manchester City FC",
  @winner=2>,
  ...]
```

Now tally up all matches for the standings table with the standings helper class:

``` ruby
standings = Standings.new( matches )
pp standings
```

will pretty print (pp):

```
#<Sports::Standings
 @lines=
  {"Liverpool FC"=>
    #<Sports::StandingsLine
     @away_drawn=0,
     @away_goals_against=1,
     @away_goals_for=5,
     @away_lost=0,
     @away_played=2,
     @away_pts=6,
     @away_won=2,
     @drawn=0,
     @goals_against=3,
     @goals_for=12,
     @home_drawn=0,
     @home_goals_against=2,
     @home_goals_for=7,
     @home_lost=0,
     @home_played=2,
     @home_pts=6,
     @home_won=2,
     @lost=0,
     @played=4,
     @pts=12,
     @rank=nil,
     @team="Liverpool FC",
     @won=4>,
   "Norwich City FC"=>
    #<Sports::StandingsLine
     @away_drawn=0,
     @away_goals_against=6,
     @away_goals_for=1,
     @away_lost=2,
     @away_played=2,
     @away_pts=0,
     @away_won=0,
     @drawn=0,
     @goals_against=10,
     @goals_for=6,
     @home_drawn=0,
     @home_goals_against=4,
     @home_goals_for=5,
     @home_lost=1,
     @home_played=2,
     @home_pts=3,
     @home_won=1,
     @lost=3,
     @played=4,
     @pts=3,
     @rank=nil,
     @team="Norwich City FC",
     @won=1>,  ...>
```

Now let's format the standings for humans :-) in the classic more compact table format.
Let's start with
showing only totals - no home/away break outs yet -
in the first simple version:

``` ruby
standings.each do |l|
  print '%2d. '     % l.rank
  print '%-28s  '   % l.team
  print '%2d '      % l.played
  print '%3d '      % l.won
  print '%3d '      % l.drawn
  print '%3d '      % l.lost
  print '%3d:%-3d ' % [l.goals_for,l.goals_against]
  print '%3d'       % l.pts
  print "\n"
end
```

resulting in:

```
 1. Liverpool FC                  38  32   3   3  85:33   99
 2. Manchester City FC            38  26   3   9 102:35   81
 3. Manchester United FC          38  18  12   8  66:36   66
 4. Chelsea FC                    38  20   6  12  69:54   66
 5. Leicester City FC             38  18   8  12  67:41   62
 6. Tottenham Hotspur FC          38  16  11  11  61:47   59
 7. Wolverhampton Wanderers FC    38  15  14   9  51:40   59
 8. Arsenal FC                    38  14  14  10  56:48   56
 9. Sheffield United FC           38  14  12  12  39:39   54
10. Burnley FC                    38  15   9  14  43:50   54
11. Southampton FC                38  15   7  16  51:60   52
12. Everton FC                    38  13  10  15  44:56   49
13. Newcastle United FC           38  11  11  16  38:58   44
14. Crystal Palace FC             38  11  10  17  31:50   43
15. Brighton & Hove Albion FC     38   9  14  15  39:54   41
16. West Ham United FC            38  10   9  19  49:62   39
17. Aston Villa FC                38   9   8  21  41:67   35
18. AFC Bournemouth               38   9   7  22  40:65   34
19. Watford FC                    38   8  10  20  36:64   34
20. Norwich City FC               38   5   6  27  26:75   21
```

To wrap up let's break out the standings for home and away matches for a deluxe version:

``` ruby
print "                                        - Home -          - Away -            - Total -\n"
print "                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts\n"

standings.each do |l|
  print '%2d. '  % l.rank
  print '%-28s  ' % l.team
  print '%2d  '     % l.played

  print '%2d '      % l.home_won
  print '%2d '      % l.home_drawn
  print '%2d '      % l.home_lost
  print '%3d:%-3d  ' % [l.home_goals_for,l.home_goals_against]

  print '%2d '       % l.away_won
  print '%2d '       % l.away_drawn
  print '%2d '       % l.away_lost
  print '%3d:%-3d  ' % [l.away_goals_for,l.away_goals_against]

  print '%3d:%-3d ' % [l.goals_for,l.goals_against]

  goals_diff = l.goals_for-l.goals_against
  if goals_diff > 0
    print '%3s  '  %  "+#{goals_diff}"
  elsif goals_diff < 0
    print '%3s  '  %  "#{goals_diff}"
  else ## assume 0
    print '     '
  end

  print '%3d'  % l.pts
  print "\n"
end
```

resulting in:

```
                                        - Home -          - Away -            - Total -
                                 Pld   W  D  L   F:A     W  D  L   F:A      F:A   +/-  Pts
 1. Liverpool FC                  38  18  1  0  52:16   14  2  3  33:17    85:33  +52   99
 2. Manchester City FC            38  15  2  2  57:13   11  1  7  45:22   102:35  +67   81
 3. Manchester United FC          38  10  7  2  40:17    8  5  6  26:19    66:36  +30   66
 4. Chelsea FC                    38  11  3  5  30:16    9  3  7  39:38    69:54  +15   66
 5. Leicester City FC             38  11  4  4  35:17    7  4  8  32:24    67:41  +26   62
 6. Tottenham Hotspur FC          38  12  3  4  36:17    4  8  7  25:30    61:47  +14   59
 7. Wolverhampton Wanderers FC    38   8  7  4  27:19    7  7  5  24:21    51:40  +11   59
 8. Arsenal FC                    38  10  6  3  36:24    4  8  7  20:24    56:48   +8   56
 9. Sheffield United FC           38  10  3  6  24:15    4  9  6  15:24    39:39        54
10. Burnley FC                    38   8  4  7  24:23    7  5  7  19:27    43:50   -7   54
11. Southampton FC                38   6  3 10  21:35    9  4  6  30:25    51:60   -9   52
12. Everton FC                    38   8  7  4  24:21    5  3 11  20:35    44:56  -12   49
13. Newcastle United FC           38   6  8  5  20:21    5  3 11  18:37    38:58  -20   44
14. Crystal Palace FC             38   6  5  8  15:20    5  5  9  16:30    31:50  -19   43
15. Brighton & Hove Albion FC     38   5  7  7  20:27    4  7  8  19:27    39:54  -15   41
16. West Ham United FC            38   6  4  9  30:33    4  5 10  19:29    49:62  -13   39
17. Aston Villa FC                38   7  3  9  22:30    2  5 12  19:37    41:67  -26   35
18. AFC Bournemouth               38   5  6  8  22:30    4  1 14  18:35    40:65  -25   34
19. Watford FC                    38   6  6  7  22:27    2  4 13  14:37    36:64  -28   34
20. Norwich City FC               38   4  3 12  19:37    1  3 15   7:38    26:75  -49   21
```


That's it.
Bonus: Why not build a standings table for the Bundesliga, La Liga, Ligue 1, Seria A, or your very own league? Yes, you can.



## Installation

Use

    gem install sports

or add the gem to your Gemfile

    gem 'sports'


## License

The `sports` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum/Mailing List](http://groups.google.com/group/opensport).
Thanks!
