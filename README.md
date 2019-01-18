# The Point of Improbable Return
*This project was created as part of the Data Analytics class at Galvanize and highlights my skills using SQL, [Tableau](https://public.tableau.com/profile/stephen.hwang#!/vizhome/PointofImprobableReturn/PointofImprobableReturnDashboard) and Excel.- Stephen Hwang*

![POIRimage1](https://github.com/stvhwang/nba2016-17/blob/master/mike-conley-marc-gasol-pick.jpg "Marc Gasol and Mike Conley, players who led the Memphis Grizzles to multiple come-from-behind wins.")
             
| ***** | Have you ever watched an NBA game, where one team is leading by a large margin, and wondered if the trailing team had enough time to mount a comeback and win?  And which players are effective in leading a comeback win? | ***** | 
| --- | ---      | --- |


The project's aim is to query games from the NBA's play by play data for the 2016-17 season and evaluating a threshold when a game's point differential is unlikely to overcome by the losing team. I call this threshold the "Point of Improbable Return". Nominally, I set it to trigger when the scoring differential is twice that of time remaining in minutes.

After finding some games where a comeback was successful, querying which players score the most in the time after this threshold. The premise is to find the players who have the ability score to help their team overcome a losing situation and help produce a come-from-behind win.
### Table of Contents
1. [Loading](#1-loading-and-formatting-data) and formatting Game Data (SQL)
2. [Evaluating](#2-evaluating-games) games reaching POIR, and determining if comebacks are successful.
3. [Summing](#3-summing-player-scoring) the player scoring after POIR is reached only for the winning team.
4. [Unioning](#4-unioning-player-scoring) player scoring from all POIR games and order by highest scoring.
5. [Excel](#5-excel-manipulation) manipulation of results, cross referenced with player data. (WIP)
6. [Tableau](#6-tableau-visualization) visualization of results. (WIP)
7. [Notes](#7-notes-on-data) on Data

## 1. Loading and formatting data
* NBA game data for the 2016-2017 season was sourced from this [link](https://drive.google.com/file/d/0B5QcyddjOpKOODZjZ0FJU3JSakU/view).  The original csv looks like [this](https://raw.githubusercontent.com/stvhwang/nba2016-17/master/CleanNBA/0021600001.csv)
* [CreateNBA.sql](https://github.com/stvhwang/nba2016-17/blob/master/CleanNBA/CreateNBA.sql) creates the database schema and loads in game .csv files as table
* [CleanNBA.sql](https://github.com/stvhwang/nba2016-17/blob/master/CleanNBA/CleanNBA.sql) query retrieves scoring events and formats the game for subsequent queries.
  * It retrieves data using WHERE to only pull scoring events and ignore missed ('null') freethrows
  * To make the scoring margin integers, CASE is used to replace 'TIE' with '0'
  * It applies a WITH AS structure as a subqueries to recast and format the game time.
  * Adds a ROW_NUMBER so a SELF JOIN can calculate points scored at each row.
  * An example table of a game's scoring data [FullScoring](https://github.com/stvhwang/nba2016-17/blob/master/CleanNBA/FullScoring_game0021600001.csv)

## 2. Evaluating games
The [POIRGameCheck.sql](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck.sql) finds the row WHERE the threshold was reached.
  * The POIRGameCheck query uses the full game query with common table expressions (CTE's)
  * A pair of SUBQUERIES using LIMIT in the WHERE clause find the first row and end game scoring margins.
  * Then a CASE statement evaluates the product and outputs the game's outcome
     * if a game had the [prevailing team winning](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck-game0021600001.csv) or if the [trailing team cameback to win](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck-game0021600009.csv).

## 3. Summing player scoring
After finding 14 games (out of 200 games checked)that had a successful comeback, [POIRPlayers.sql](https://github.com/stvhwang/nba2016-17/blob/master/POIRPlayers/POIRPlayers.sql) queries for players who contributed scoring in the unlikely comeback.
  * The losing team is determined by a subquery of the team reaching the threshold.
  * It exclude scores from losing team when aggregates the sum of points per contributing player. An [exmaple](https://github.com/stvhwang/nba2016-17/blob/master/POIRPlayers/POIRPlayers_game0021600009.csv)

## 4. Unioning player scoring
By Unioning the POIRPlayers tables, we can find the players who contributed the most scoring in comeback games.
  * [UNION](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRUnion.sql) query will make each player have a distinct entry. And this table will overwrite player data who appear multiple times. [Result](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRUnion.csv)
  * [UNION ALL](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRUnionAll.sql) POIRPlayers gives a list of players in a combined table listing players multiple times. [Result](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRUnionAll.csv)
  * [HAVING](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRUnionGames.sql) filters the aggregate values for players with multiple games and more than 5 minutes of POIR play. [Shown here](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRUnionGames.csv)
  
Isolating data from two games,[one](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRPlayers_Game1.csv) and [two](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRPlayers_Game2.csv) by the same comeback team can demonstrate
SQL and resulting tables can be viewed in line [here](https://github.com/stvhwang/nba2016-17/blob/master/Joins/README.md).
  * [FULL JOIN](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRPlayers_FullOuterJoin.sql) will combine the player's scoring with each game as a column. [Result](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRPlayers_FullOuterJoin.csv)
  * [INNER JOIN](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRPlayers_InnerJoin.sql) between two games with the same team find players who helped in both of two comebacks. [Result](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRPlayers_InnerJoin.csv)
  * [LEFT JOIN](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRPlayers_LeftJoin.sql) takes all the players from game 1 and adds data from game 2 but not any new game 2 rows. [seen here](https://github.com/stvhwang/nba2016-17/blob/master/Joins/POIRPlayers_LeftJoin.csv)

## 5. Excel manipulation
Excel was used as an alternative method to clean up a full game's scoring data, matching players with their teams, and filter their scoring by shot type in a pivot table. Files can be downloaded from [here](https://github.com/stvhwang/nba2016-17/tree/master/Excel).
  * Using Substitute, Find, Len, Left and Right functions to create a clean score, splitting home and visitor team points.
    * Link to raw [xlsx file](https://github.com/stvhwang/nba2016-17/blob/master/Excel/FullPoints_game0026100001_CleanScore.xlsx?raw=true).
  * Vlookup was used to find the team abbreviation for each player who scored.
     * Link to raw [xlsx file](https://github.com/stvhwang/nba2016-17/blob/master/Excel/FullPoints_game0026100001_Vlookup.xlsx?raw=true).
  * Index and Match was an alternate method to pair the player and their team abbreviation.
     * Link to raw [xlsx file](https://github.com/stvhwang/nba2016-17/blob/master/Excel/FullPoints_game0026100001_IndexMatch.xlsx?raw=true).
  * A Pivot table displays scoring by player viewable by gametime and filterable by team and shot type
    * Link to raw [xlsx file](https://github.com/stvhwang/nba2016-17/blob/master/Excel/FullPoints_game0026100001_PivotTable.xlsx?raw=true).

## 6. Tableau visualization
This data is then visualized in a series of crosslinked Tableau dashboards.
  * The [Main Dashboard](https://public.tableau.com/profile/stephen.hwang#!/vizhome/PointofImprobableReturn/PointofImprobableReturnDashboard) combines the following charts with filters for teams and player by games and minutes played. 
    * Players who scored in comeback games after reaching POIR
    * Total team POIR points
    * Treemap of total player POIR points
    * Bar graph of game outcomes at POIR and comback perecentage
  * The [Player Dashboard](https://public.tableau.com/profile/stephen.hwang#!/vizhome/PointofImprobableReturn/POIRPlayerDashboard?publish=yes) adds more detail:
    * Player POIR Points per player and per game.
  * The [Team Dashboard](https://public.tableau.com/profile/stephen.hwang#!/vizhome/PointofImprobableReturn/POIRTeamDashboard?publish=yes) is a larger view of Team points and Player total scoring Treemap.
  * The [Minute POIR Reached vs. Scoring](https://public.tableau.com/profile/stephen.hwang#!/vizhome/PointofImprobableReturn/MInutePOIRReachedDashboard?publish=yes) margin uses a dual axis chart:
    * The scoremargin when a game reached POIR.
    * How many games reached POIR with a given number of minutes left in the game>
    * The percent of all games the comback games represent at the minute period.

## 7. Notes on data
I've attended 30-50 NBA games in my life and watch many more on TV. I invented this metric to help me view if a game was close or if one team was getting blown out. Also, if a team's window to mount a comeback was available, closing, or out of reach.

* I'd like to tweak the formula to add a constant of 1-5 points. For example, 2 x minutes left + 2 point = amount the losing team could come back. As is, I found 14 games out of 200, or 7% of game, are successful comeback games. Given a season or more of data, adjusting the algorithm to find about 5% of games would be my desire. For a fan in the stands, a simple formula is easy to calculate in your head would make it more accessible as a rule of thumb.

* For a coach, knowing which players could effect a comeback would be interesting. Expanding the query to include 5-man teams, the arena and particular opponents would help inform which players to substitute into the game.

* Applying machine learning and training game sets would also be interesting to fine tune the formula. Just like how televised poker shows percentages of a player's hand will win, a running percentage in realtime of the likelihood a team will successfully comeback would be interesting. This is particularly interesting since the NBA is movoing towards basketball [sports betting](http://www.espn.com/chalk/story/_/id/24248120/gambling-need-know-nba-sports-betting-partnership), and advances like [Clippers CourtVision](https://www.clipperscourtvision.com) have started showing near-realtime stats during game broadcasts.

* While cleaner game-by-game data can be purchased, I found some less-structured public data that I could help demonstrate how I cleaned and formatted the data for use.

* I manually loaded multiple games into the Postgres database, and checked them individually if they satisfied the POIR games I was looking for. Given time, I'd write a python script to load in all 1230 games in the season and performs this check and output all POIR games.

* Of the 200 games checked was one edge case game, which didn't yeild a result from the POIRGameCheck.sql.  Upon further investigation, the game never triggered the POIR check, always staying withing a scoring margin less than 2 x the minutes remaining. I also adjusted the minutes remaining calculation to take overtime periods in account. While it didn't occur in the games checked, if a game only hit the POIR threshold in overtime, the POIRGameCheck.sql would report it.

* Known issues: 
  * I take the time the POIR conditon is met to the end of the game to calculate a rate for a player's scoring, without knowing if a player was substitued in or not.
  * While some teams and players show up as effective in comebacks, it could also mean those teams with those players have a tendency to get behind by large point marginss early in the game, giving them more opportunities to showcase their sklls in comeback wins.
