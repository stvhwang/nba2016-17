# Using two Memphis Grizzly games to show Full, Inner and Left Joins.

## Games 1 table of POIR players
|"player_name"|"player_points"|"player_team_abbreviation"|
| --- | --- | --- |
|"JaMychal Green"|4|"MEM"|
|"Mike Conley"|4|"MEM"|
|"Marc Gasol"|2|"MEM"|
|"Andrew Harrison"|1|"MEM"|

## Game 2 table of POIR players.
|"player_name"|"player_points"|"player_team_abbreviation"|
| --- | --- | --- |
|"Marc Gasol"|11|"MEM"|
|"Mike Conley"|11|"MEM"|
|"Vince Carter"|2|"MEM"|

## Full Join
```
select game1.player_name as "Game 1 Player"|
	game2.player_name as "Game 2 Player"|
	game1.player_points as "Game 1 Points"|
	game2.player_points as "Game 2 Points"
from da_nba.poirplayers_game0021600009 game1
full outer join da_nba.poirplayers_game0021600039 game2
on game1.player_name = game2.player_name
```
Results : Shows all players from both games
"Game 1 Player"|"Game 2 Player"|"Game 1 Points"|"Game 2 Points"
| --- | --- | --- | --- |
|"Andrew Harrison"|""|1|""|
|"JaMychal Green"|""|4|""|
|"Marc Gasol"|"Marc Gasol"|2|11|
|"Mike Conley"|"Mike Conley"|4|11|
|""|"Vince Carter"|""|2|

## Inner Join
```
select game1.player_name| game1.player_points| game2.player_points
from da_nba.poirplayers_game0021600009 game1
join da_nba.poirplayers_game0021600039 game2
on game1.player_name = game2.player_name
```
Results: Shows only players who scored in both games.
"player_name"|"player_points"|"player_points-2"
| --- | --- | --- |
|"Marc Gasol"|2|11|
|"Mike Conley"|4|11|

## Left Join
```
select game1.player_name| game1.player_points| game2.player_points
from da_nba.poirplayers_game0021600009 game1
left join da_nba.poirplayers_game0021600039 game2
on game1.player_name = game2.player_name
```
Results: Shows all players from game1, with game 2 scoring, but no new game2 only players.
|"player_name"|"player_points"|"player_points-2"|
| --- | --- | --- | --- |
|"Andrew Harrison"|1|""|
|"JaMychal Green"|4|""|
|"Marc Gasol"|2|11|
|"Mike Conley"|4|11|
