#################
#  to run use:
#    $ ruby sandbox/datasets.rb


$LOAD_PATH.unshift( './lib' )
require 'football/timezones'



pp parse_datasets( <<TXT )
league,   seasons
at.1,     2024/25 2023/24 2022/23 2021/22 2020/21
at.2,     2024/25 2023/24 2022/23 2021/22 2020/21
at.3.o,   2024/25 2023/24 2022/23 2021/22 2020/21
at.cup,   2024/25 2023/24 2022/23 2021/22 2020/21
TXT

pp read_datasets( './datasets/at.csv' )


args = ['at.1', '2023/24']
pp parse_datasets_args( args )

args = ['at.1', '2024/25', '2023/24']
pp parse_datasets_args( args )

args = ['at.cup']
pp parse_datasets_args( args )

args = ['br.1', '2024']
pp parse_datasets_args( args )



pp parse_datasets( <<TXT )
league,   seasons
at.1,     2020/21..2024/25
at.2,     2020/21..2023/24
at.3.o,   2021/22..2023/24 2025/26
br.1,     2020..2024 2025 2027
TXT



puts "bye"
