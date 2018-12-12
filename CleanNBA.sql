select * from da_nba.game0021600001
limit 20

select pctimestring, period, eventmsgtype, eventmsgactiontype, homedescription, score, scoremargin from da_nba.game0021600001
where eventmsgtype = 1
