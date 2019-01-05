-- POIRGameCheck.sql
-- query a game and compare the first scoremargin with the last.
-- if first and last row are both (positive or negative), then the leading team won.
-- each positive scoremargin = home team leads, each negative scoremargin = visiting team leads.
-- a negative product of both indicates a comeback win, beating the Point of Improbable Return.
							   
With full_game as (
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
	from da_nba.game0021600050
	where (eventmsgtype = 1 or eventmsgtype = 3) and (score != 'null')
	)
--add row numering for all baskets scored, event message type 1 and 3, 
--excludes event type 3 with null in the score, which are missed free throws.
--converts game minutes and seconds into integers
--the difference of the scoremargin for each row and the row prior is how many points scored
select 
	distinct(gta.row_number),
	gta.eventnum,
	gta.minute_adjusted,
	gta.scoremargin,
	(ABS(gta.scoremargin::integer - gtb.scoremargin::integer)) points_scored
from da_nba.game0021600050 nba, game_time gta, game_time gtb 
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
	 a.row_number as row_poir_start,
	 a.scoremargin as begin_scoremargin,
	 b.row_number as row_end_score,
	 b.scoremargin as end_scoremargin,
	 (a.scoremargin::integer * b.scoremargin::integer) as "neg=comeback",
	 case 
	 	when (a.scoremargin::integer * b.scoremargin::integer) < 0 then 'a successful comeback win for the trailing team'
	 	else 'the leading team prevails and wins'
	 	end as "Did the trailing team overcome POIR to beat the leading team?"
from full_game a, full_game b
where a.row_number = (
--determines the first row the PIOR check is met
select 
	row_number
from full_game
where (ABS(scoremargin::integer)) >= (2*minute_adjusted)
limit 1
)
	and b.row_number = (
--determines the last row the game, by reversing order
select 
	row_number
from full_game
where (ABS(scoremargin::integer)) >= (2*minute_adjusted)
order by row_number desc
limit 1	)

			
			

