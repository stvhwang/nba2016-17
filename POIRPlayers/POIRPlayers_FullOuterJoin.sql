--POIRPlayers_FullOuterJoin.sql
--Joins the POIRplayers from the two Memphis game tables
--Finds POIRplayers in any or both games.

select game1.player_name as "Game 1 Player", 
	game2.player_name as "Game 2 Player", 
	game1.player_points as "Game 1 Points", 
	game2.player_points as "Game 2 Points"
from da_nba.poirplayers_game0021600009 game1
full outer join da_nba.poirplayers_game0021600039 game2
on game1.player_name = game2.player_name
