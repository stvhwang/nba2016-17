--POIRPlayers.sql
--Sums up point per player from the POIR table
--Computes minutes from when POIR is satisfied to end of game, including overtimes.
select min_added.player, min_added.POIR_points, min_added.team,
	-- a period of 5 or more indicates overtime, each of 5 min
	case
		when max_period >4 then (max_minute + ((max_period -4)*5))
		else max_minute
		end as true_max_min
from
(
select pg.player, pg.POIR_points, pg.team,
	-- subquery to find max minute_adjusted
	(
	With full_game as (
	With game_time as (
		--converts the hh:mm:ss to be mm:ss, adding 12 min per period leaving period 4 and OT unadjusted.
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
		from da_nba.game0021600009
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
		period,
		player1_name player,
		player1_team_abbreviation team,
		score,
		gta.scoremargin,
		(ABS(gta.scoremargin::integer - gtb.scoremargin::integer)) points_scored
	from da_nba.game0021600009 nba, game_time gta, game_time gtb 
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
		minute_adjusted
	from full_game
	where row_number = (
	--determines the first row the PIOR check is met
	--for if a comeback is successful, the POIR check will not be met
	select 
		row_number
	from full_game
	where (ABS(scoremargin::integer)) >= (2*minute_adjusted)
	limit 1
	)) max_minute,  
	
	--subquery to find max period
	(select 
		max(period) as max_period
	from da_nba.game0021600009
	limit 1
	) max_period
from (
select player, sum(points_scored) POIR_points, team
from (
With full_game as (
With game_time as (
	--converts the hh:mm:ss to be mm:ss, adding 12 min per period leaving period 4 and OT unadjusted.
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
	from da_nba.game0021600009
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
from da_nba.game0021600009 nba, game_time gta, game_time gtb 
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
and team !=(
-- the team that scores when POIR activates is the leading team
-- so track players who are not on the leading team
select 
	team
from full_game
where (ABS(scoremargin::integer)) >= (2*minute_adjusted)
limit 1
)
) poir_game
group by player, team
order by POIR_points desc
) pg 
) min_added   
	   
	   

	   
