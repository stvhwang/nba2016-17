# The Point of Improbable Return
*This project was created as part of the Data Analytics class at Galvanize and highlights my skills using SQL, Tableau and Excel.- Stephen Hwang*

![POIRimage1](https://github.com/stvhwang/nba2016-17/blob/master/mike-conley-marc-gasol-pick.jpg "Marc Gasol and Mike Conley")
             
| ***** | Have you ever watched an NBA game, where one team is leading by a large margin, and wondered if the trailing team had enough time to mount a comeback and win?  And which players are effective in leading a comeback win? | ***** | 
| --- | ---      | --- |


The project's aim is to query games from the NBA's play by play data for the 2016-17 season and determine the threshold when a game's point differential is unlikely to overcome by the losing team. I call this threshold the "Point of Improbable Return". Nominally, I set it to trigger when the scoring differential is twice that of time remaining in minutes.

After finding some games where a comeback was successful, querying which players score the most in the time after this threshold. The premise is to find the players who have the ability score to help their team overcome a losing situation and help produce a come-from-behind win.
### Table of Contents
1. [Loading](#1-loading-and-formatting-data) and formatting Game Data (SQL)
2. [Evaluating](#2-evaluating-games) games reaching POIR, and determining if comebacks are successful.
3. [Summing](#3-summing-player-scoring) the player scoring after POIR is reached only for the winning team.
4. [Unioning](#4-unioning-player-scoring) player scoring from all POIR games and order by highest scoring.
5. [Excel](#5-excel-manipuation) manipulation of results, cross referenced with player data. (WIP)
6. [Tableau](#6-tableau-visualization) visualization of results. (WIP)
7. [Notes](#7-notes-on-data) on Data

## 1. Loading and formatting data
* NBA game data for the 2016-2017 season was sourced from this [link](https://drive.google.com/file/d/0B5QcyddjOpKOODZjZ0FJU3JSakU/view)
* [CreateNBA.sql](https://github.com/stvhwang/nba2016-17/blob/master/CreateNBA.sql) creates the database schema and loads in game .csv files as table
* [CleanNBA.sql](https://github.com/stvhwang/nba2016-17/blob/master/CleanNBA.sql) query retrieves scoring events and formats the game for subsequent queries.
  * It retrieves data using WHERE to only pull scoring events and ignore missed ('null') freethrows
  * To make the scoring margin integers, CASE is used to replace 'TIE' with '0'
  * It applies a WITH AS structure as a subqueries to recast and format the game time.
  * Adds a ROW_NUMBER so a SELF JOIN can calculate points scored at each row.
  * An example table of a game's scoring data [FullScoring](https://github.com/stvhwang/nba2016-17/blob/master/FullScoring_game0021600001.csv)

## 2. Evaluating games
The [POIRGameCheck.sql](https://github.com/stvhwang/nba2016-17/tree/master/POIRGameCheck) finds the row WHERE the threshold was reached.
  * The POIRGameCheck query uses the full game query with common table expressions (CTE's)
  * A pair of SUBQUERIES using LIMIT in the WHERE clause find the first row and end game scoring margins.
  * Then a CASE statement evaluates the product result and outputs the game's outcome.

## 3. Summing player scoring
After finding a several games (out of 50 games checked)that had a successful comeback, [POIRPlayers.sql](https://github.com/stvhwang/nba2016-17/tree/master/POIRPlayers) queries for players who contributed scoring in the unlikely comeback.
  * The losing team is determined by a subquery of the team reaching the threshold,
  * It exclude scores from losing team when aggregates the sum of points per contributing player.

## 4. Unioning player scoring
By Unioning the POIRPlayers tables, we can find the players who contributed the most scoring in comeback games.
  * UNION ALL POIRPlayers gives a list of players in a combined table with redundancy.
  * UNION query will make each player have a distinct entry.
  * FULL JOIN will combine the player's scoring with each game as a column.
  * INNER JOIN between two games with the same team find players who helped in both comebacks.
  * OUTER JOIN in this case will list players who helped in only one of the comeback games.

## 5. Excel manipulation
Excel was used as an alternative method to clean up a full game's scoring data, matching players with their teams, and filter their scoring by shot type in a pivot table
  * Using Substitute, Find, Len, Left and Right functions to create a clean score, splitting home and visitor team points.
  * Vlookup was used to find the team abbreviation for each player who scored.
  * Index and Match was an alternate method to pair the player and their team abbreviation.
  * A Pivot table displays scoring by player viewable by gametime and filterable by team and shot type

## 6.Tableau visualization
* Dashboard
* Dual axis chart

## 7.Notes on data
I've attended 30-50 NBA games in my life and watch many more on TV. I invented this metric to help me view if a game was close or if one team was getting blown out. Also, if a team's window to mount a comeback was available, closing, or out of reach.

* I'd like to tweak the formula to add a constant of 1-5 points. For example, 2 x minutes left + 2 point = amount the losing team could come back. As is, I found 9 games out of 100, or 9% of game, are successful comeback games. Given a season or more of data, adjusting the algorithm to find about 5% of games would be my desire. For a fan in the stands, a simple formula is easy to calculate in your head would make it more accessible as a rule of thumb.

* For a coach, knowing which players could effect a comeback would be interesting. Expanding the query to include 5-man teams, the arena and particular opponents would help inform which players to substitute into the game.

* Applying machine learning and training game sets would also be interesting to fine tune the formula. Just like how televised poker shows percentages of a player's hand will win, a running percentage in realtime of the likelihood a team will successfully comeback would be interesting

* While cleaner game-by-game data can be purchased, I found some less-structured public data that I could help demonstrate how I cleaned and formatted the data for use.

* I manually loaded multiple games into the Postgres database, and checked them individually if they satisfied the POIR games I was looking for. Given time, I'd write a python script to load in all 1230 games in the season and performs this check and output all POIR games.

* Of the 100 games checked was one edge case game, which didn't yeild a result from the POIRGameCheck.sql.  Upon further investigation, the game never triggered the POIR check, always staying withing a scoring margin less than 2 x the minutes remaining. I also adjusted the minutes remaining calculation to take overtime periods in account. While it didn't occur in the games checked, if a game only hit the POIR threshold in overtime, the POIRGameCheck.sql would report it.
