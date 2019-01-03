--POIRPlayersUnion.sql
--Sums up point per player from all the POIRPlayer tables


select player_name, sum(player_points)as points, player_team_abbreviation
from (
	
--Union of all POIRplayer tables	
select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600009
union

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600033
union

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600039
union

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600046
union

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600049
union

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600060
union

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600063
union

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600075
union

select player_name, player_points, player_team_abbreviation
from da_nba.poirplayers_game0021600090
) poirplayerunion
group by player_name, player_team_abbreviation
order by points desc


