#################
#  to run use:
#    $ ruby sandbox/leaguesets.rb


$LOAD_PATH.unshift( './lib' )
require 'football/timezones'



pp parse_leagueset( <<TXT )
league,   seasons
at.1,     2024/25 2023/24 2022/23 2021/22 2020/21
at.2,     2024/25 2023/24 2022/23 2021/22 2020/21
at.3.o,   2024/25 2023/24 2022/23 2021/22 2020/21
at.cup,   2024/25 2023/24 2022/23 2021/22 2020/21
TXT

pp read_leagueset( './leaguesets/at.csv' )


args = ['at.1', '2023/24']
pp parse_leagueset_args( args )

args = ['at.1', '2024/25', '2023/24']
pp parse_leagueset_args( args )

args = ['at.cup']
pp parse_leagueset_args( args )

args = ['br.1', '2024']
pp parse_leagueset_args( args )



pp parse_leagueset( <<TXT )
league,   seasons
at.1,     2020/21..2024/25
at.2,     2020/21..2023/24
at.3.o,   2021/22..2023/24 2025/26
br.1,     2020..2024 2025 2027
TXT



puts "bye"
