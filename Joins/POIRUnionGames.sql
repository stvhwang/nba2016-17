--POIRPlayersUnionAll.sql
--Lists point per player from all the the POIRPlayer tables

select distinct(player_name),
	count(player_name) as num_games,
	sum(player_points) as sum_points,
	(round((avg(player_points))::numeric,2)) as avg_points,
	player_team_abbreviation as team,
	sum(true_max_min) as total_mins,
	(round((sum(player_points::numeric)/sum(true_max_min::numeric)),2)) as points_per_min
from
(
select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600009
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600033
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600039
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600046
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600049
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600060
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600063
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600075
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600090
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600102
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600110
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600141
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600148
union all

select player_name, player_points, player_team_abbreviation, true_max_min
from da_nba.poirplayers_game0021600185
order by player_team_abbreviation, player_name, player_points desc
) ug
-- note, ug short for union_games
group by ug.player_name, ug.player_team_abbreviation
-- elminate single game and low minute results
-- remaining player have at least 2 games and 5 poir minutes
-- this also passes the "eye-test", leading players are of all-star calibur
having count(player_name) >= 2 
		and sum(true_max_min) > 5
order by points_per_min desc
											
									 