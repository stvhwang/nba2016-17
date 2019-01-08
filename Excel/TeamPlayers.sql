--TeamPlayersNBA.sql
--Queries scoring players and their team abbreviations in a game

select distinct(player1_name), player1_id, player1_team_abbreviation
from da_nba.game0021600001 nba
where (eventmsgtype = 1 or eventmsgtype = 3) and (score != 'null')
order by 3, 1


			

