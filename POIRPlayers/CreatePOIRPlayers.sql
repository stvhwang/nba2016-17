-- NOTE: This imports the POIR Player data for one game.

BEGIN;

CREATE TABLE IF NOT EXISTS da_nba.POIRPlayers_game0021600009(
        PLAYER_NAME VARCHAR(40) PRIMARY KEY,
        PLAYER_POINTS INTEGER,
        PLAYER_TEAM_ABBREVIATION VARCHAR(3),
		TRUE_MAX_MIN INTEGER
        );

DELETE FROM da_nba.POIRPlayers_game0021600009;

-- UPDATE THIS PATH:
COPY da_nba.POIRPlayers_game0021600009 FROM '/Users/shwang/Documents/Data Analytics Class/NBA/nba2016-17/POIRPlayers/POIRPlayers_game0021600009.csv'
WITH DELIMITER ',' CSV HEADER;


COMMIT;

--SELECT * FROM da_nba.POIRPlayers_game0021600009
--limit 10