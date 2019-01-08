--POIRPlayers_InnerJoin.sql
--Joins the POIRplayers from the two Memphis game tables
--Finds POIRplayers who are common to both games

select game1.player_name
from da_nba.poirplayers_game0021600009 game1
join da_nba.poirplayers_game0021600039 game2
on game1.player_name = game2.player_name

