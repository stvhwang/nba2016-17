-- NOTE: This creates the da_nba schema, and imports the play by play data for one game.

BEGIN;

CREATE TABLE IF NOT EXISTS da_nba.POIRPlayers_game0021600049(
        PLAYER_NAME VARCHAR(40) PRIMARY KEY,
        PLAYER_POINTS INTEGER,
        PLAYER_TEAM_ABBREVIATION VARCHAR(3)
        );

DELETE FROM da_nba.POIRPlayers_game0021600049;

-- UPDATE THIS PATH:
COPY da_nba.POIRPlayers_game0021600049 FROM '/Users/shwang/Documents/Data Analytics Class/NBA/nba2016-17/POIRPlayers/POIRPlayers_game0021600049.csv'
WITH DELIMITER ',' CSV HEADER;


COMMIT;

--SELECT * FROM da_nba.POIRPlayers_game0021600009
--limit 10