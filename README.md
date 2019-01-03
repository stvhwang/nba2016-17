# nba2016-17 Project : The Point of Improbable Return
**This is a work in progress**
*This project was created as part of the Data Analytics class at Galvanize and highlights my skills using SQL, Tableau and Excel.*

The project's aim is to query games from the NBA's play by play data for the 2016-17 season and determine the threshold when a game's point differential is unlikely to overcome by the losing team. I call this threshold the "Point of Improbable Return". Nominally, I set it trigger when the scoring differential is twice that of time remaining in minutes.

After finding some games where a comeback was successful, querying which players score the most in the time after this threshold. The premise is to find the players who have the ability score to help their team overcome a losing situation and help produce a come-from-behind win.

*NBA game data for the 2016-2017 season source from this [link](https://drive.google.com/file/d/0B5QcyddjOpKOODZjZ0FJU3JSakU/view)

## Table of Contents (SQL)

1. Loading and formatting game play-by-play data.
* [CreateNBA.sql](https://github.com/stvhwang/nba2016-17/blob/master/CreateNBA.sql) creates the database schema and loads in game .csv files as table

* [CleanNBA.sql](https://github.com/stvhwang/nba2016-17/blob/master/CleanNBA.sql) query retrieves scoring events and formats the game for subsequent queries.
  * It retrieves data using WHERE to only pull scoring events and ignore missed ('null') freethrows
  * To make the scoring margin integers, CASE is used to replace 'TIE' with '0'
  * It applies a WITH AS structure as a subqueries to recast and format the game time.
  * Adds a ROW_NUMBER so a SELF JOIN can calculate points scored at each row.
  * An example table of a game's scoring data [FullScoring](https://github.com/stvhwang/nba2016-17/blob/master/FullScoring_game0021600001.csv)

2. To find games that reach the "Point of Improbable Return" the [POIRGameCheck.sql](https://github.com/stvhwang/nba2016-17/tree/master/POIRGameCheck) finds the row WHERE the threshold was reached.
  * The POIRGameCheck query uses the full game query with common table expressions (CTE's)
  * A pair of SUBQUERIES using LIMIT in the WHERE clause find the first row and end game scoring margins.
  * Then a CASE statement evaluates the product result and outputs the game's outcome.

3. After finding a several games (out of 50 games checked)that had a successful comeback, [POIRPlayers.sql](https://github.com/stvhwang/nba2016-17/tree/master/POIRPlayers) queries for players who contributed scoring in the unlikely comeback.
  * The losing team is determined by a subquery of the team reaching the threshold,
  * It exclude scores from losing team when aggregates the sum of points per contributing player.

4. (WIP) By Unioning the POIRPlayers tables, we can find the players who contributed the most scoring in comeback games.
  * UNION ALL POIRPlayers gives a list of players in a combined table with redundancy.
  * UNION query will make each player have a distinct entry.
  * FULL JOIN will combine the player's scoring with each game as a column.
  * INNER JOIN between two games with the same team find players who helped in both comebacks.
  * OUTER JOIN in this case will list players who helped in only one of the comeback games.

## Visualizations (Tableau)
* Dashboard
* Dual axis chart

## Notes on the data
I've attended 30-50 NBA games in my life and watch many more on TV. I invented this metric to help me view if a game was close or if one team was getting blown out. Also, if a team's window to mount a comeback was available, closing, or out of reach.

* I'd like to tweak the formula to add a constant of 1-5 points, so 2 x minutes left + 2 point = amount the losing team could come back. As is, I found 5 games out of 50, or 10% of games. Given season of more of data, adjusting the algorithm to find about 5% of games would be my desire As a fan in the stands, a simple formula is easy to calculate in your head.

* For a coach, knowing which players could effect a comeback would be interesting, though expanding the query to 5-man teams, taking in account who the opponent is would help inform which players to check into the game.

* Applying machine learning and training game sets would also be interesting to fine tune the formula. Just like how televised poker shows percentages of a player's hand will win, a running percentage in realtime of the likelihood a team will successfully comeback would be interesting

* While cleaner game-by-game data can be purchased, I found some less-structured public data that I could help show how I cleaned and formatted the data for use.
* I manually loaded multiple games into the Postgres database, and checked them individually if they satisfied the POIR games I was looking for. Given time, I'd write a python script to load in all 1230 games in the season and performs this check and output all POIR games.
