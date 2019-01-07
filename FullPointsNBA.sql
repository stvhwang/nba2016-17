--FullPointsNBA.sql
--Queries game play by play, tracking only scoring events
--Displays all rows without points_scored. Point per shot to be calculated in Excel.

With game_time as (
	--converts the hh:mm:ss to be mm:ss, adding 12 min per period and leaving period 4 and OT unadjusted.
	--Also replaces 'TIE' in the score margin with '0'
	select
		ROW_NUMBER () OVER (ORDER BY eventnum),
		CASE
			WHEN period <= 3 THEN (DATE_PART('hour', pctimestring)::integer+((4-period)*12)) 
			ELSE (DATE_PART('hour', pctimestring)::integer)
			END as minute_adjusted,
		DATE_PART('minute', pctimestring) as game_second,
		eventnum,
		Case
			when scoremargin = 'TIE' then '0'
			else scoremargin
		end
	from da_nba.game0021600001
	where (eventmsgtype = 1 or eventmsgtype = 3) and (score != 'null')
	)
--add row numering for all baskets scored, event message type 1 and 3, 
--excludes event type 3 with null in the score, which are missed free throws.
--converts game minutes and seconds into integers
--the difference of the scoremargin with the row prior is how many points scored
--This elminates row 1, but it's okay since it isn't used for POIR calculations.
select 
	distinct(gta.row_number),
	gta.minute_adjusted,
	gta.game_second::integer seconds,
	player1_name player,
	score,
	gta.scoremargin
--	(ABS(gta.scoremargin::integer - gtb.scoremargin::integer)) points_scored
from da_nba.game0021600001 nba, game_time gta 
	where 
	(eventmsgtype = 1 or eventmsgtype = 3) and (score != 'null')
	and nba.eventnum = gta.eventnum
--	and gta.row_number = (gtb.row_number + 1)
Order by gta.row_number

			

