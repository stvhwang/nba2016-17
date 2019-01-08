--POIRPlayers_LeftJoin.sql
--Joins the POIRplayers from the first Memphis game table 
--and adds the second game players only if they were also in the first table 

select game1.player_name, game1.player_points, game2.player_points
from da_nba.poirplayers_game0021600009 game1
left join da_nba.poirplayers_game0021600039 game2
on game1.player_name = game2.player_name

