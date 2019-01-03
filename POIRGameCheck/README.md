# POIR Game Check

## Query
To find games that reach the "Point of Improbable Return" the [POIRGameCheck.sql](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck.sql) finds the row WHERE the threshold was reached.
  * The POIRGameCheck query uses the full game query with common table expressions (CTE's)
  * A pair of SUBQUERIES using LIMIT in the WHERE clause find the first row and end game scoring margins.
  * Then a CASE statement evaluates the product result and outputs the game's outcome.

## Logic
The logic is that the team who's scoring basket meets the POIR threshold is the leading team. It's scoremargin will be positive or negative, and the absolute value of it will be twice number of remainnig minutes in the game.

By checking the end score margin, we can check which team won.
* At the score when POIR is satisfied (first row of table)
  * a positive scoremargin = home team is leading
  * a negative scoremargin = visiting team is leading
* Scoremargin at the end of the game (last row of table)
  * a positive scoremargin = home team won the game
  * a negative scoremargin = visiting team won the games

So by multiplying the scormargin at the start of POIR and the scoring margin at the end of the game, we can determine if the game had a comeback win.
* A positive product value indicates the leading team won the game.
  * a positive POIR scoremargin x positive End scormargin = home team lead, and won.
  * a negative POIR scoremargin x negative End scormargin = visitor team lead, and won.
* A negative product value indicates the losing team successfuly came back to win.
  * a negative POIR scoremargin x positive End scormargin = home team comeback win.
  * a positive POIR scoremargin x negative End scormargin = visitor team comeback win.

## Game Cases
When testing the first 50 games from the NBA 2016-17 dataset, there are five games that reached POIR and resulted in a comeback victory.
* Normal game without comeback win. (positive scoremargin product)
  * [game 0001](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck-game0021600001.csv) : Cleveland Cavaliers @ New York Kicks
* Comeback game (negative scoremargin product)
  * [game 0009](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck-game0021600009.csv) : Minnesota Timbervolves @ Memphis Grizzlies | Memphis comesback to win.
  * [game 0033](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck-game0021600033.csv) : Portland Trailblazers @ Denver Nuggets | Portland comesback to win.
  * [game 0039](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck-game0021600039.csv) : Washington Wizards @ Memphis Grizzlies | Memphis comesback to win.
  * [game 0046](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck-game0021600046.csv) : Orlando Magic @ Philadephia| Orlando comesback to win.
  * [game 0049](https://github.com/stvhwang/nba2016-17/blob/master/POIRGameCheck/POIRGameCheck-game0021600049.csv : Sacramento Kings @ Miami Heat | Miami comesback to win.
