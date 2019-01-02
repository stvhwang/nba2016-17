--POIRGameTable.sql
-- Queries game play by play filters players and their points after the first
--instance of POIR (Point of Improbable Return) is met.

With full_game as (
With game_time as (
	--converts the hh:mm:ss to be mm:ss, adding 12 min per period.
	--Also replaces 'TIE' in the score margin with '0'
	select
		ROW_NUMBER () OVER (ORDER BY eventnum),
		(DATE_PART('hour', pctimestring)::integer+((4-period)*12)) as minute_adjusted,
		DATE_PART('minute', pctimestring) as game_second,
		eventnum,
		Case
			when scoremargin = 'TIE' then '0'
			else scoremargin
		end
	from da_nba.game0021601118
	where (eventmsgtype = 1 or eventmsgtype = 3) and (score != 'null')
	)
--add row numering for all baskets scored, event message type 1 and 3, 
--excludes event type 3 with null in the score, which are missed free throws.
--converts game minutes and seconds into integers
--the difference of the scoremargin for each row and the row prior is how many points scored
select 
	distinct(gta.row_number),
	gta.minute_adjusted,
	gta.game_second::integer seconds,
	player1_name player,
	player1_team_abbreviation team,
	score,
	gta.scoremargin,
	(ABS(gta.scoremargin::integer - gtb.scoremargin::integer)) points_scored
from da_nba.game0021601118 nba, game_time gta, game_time gtb 
	where 
	(eventmsgtype = 1 or eventmsgtype = 3) and (score != 'null')
	and nba.eventnum = gta.eventnum
	and gta.row_number = (gtb.row_number + 1)
Order by gta.row_number
) 
--filter to show only scores that happened after first instance of the POIR.
--"Point of Improbable Return" = a score margin twice that of minutes remaining.
--(formula WIP)
select 
	row_number,
	minute_adjusted,
	seconds,
	player,
	team,
	score,
	scoremargin,
	points_scored
from full_game
where row_number >= (
--determines the first row the PIOR check is met
--for if a comeback is successful, the POIR check will not be met
select 
	row_number
from full_game
where (ABS(scoremargin::integer)) >= (2*minute_adjusted)
limit 1
)
			
			

