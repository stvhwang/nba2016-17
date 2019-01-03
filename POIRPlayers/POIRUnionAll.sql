--POIRPlayersUnionAll.sql
--Sums up point per player from all the the POIRPlayer tables

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600009
union all

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600033
union all

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600039
union all

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600046
union all

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600049
order by player_team_abbreviation, player_name, player_points desc