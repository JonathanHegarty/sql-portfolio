#Create the subset Classic Rock table from listenbrainz dataset
CREATE OR REPLACE TABLE
`mydb.classicrock`
AS
SELECT
*
FROM
`listenbrainz.listenbrainz.listen`
WHERE
artist_name IN("Led Zeppelin","AC/DC","ZZ Top","Def Leppard")
;
#Insert more records into the classic rock table
INSERT INTO
`mydb.classicrock`
SELECT
*
FROM
`listenbrainz.listenbrainz.listen`
WHERE
artist_name IN("Creedence Clearwater Revival","Kiss","Steve Miller Band")
;
#Add a column (genre) to the classicrock table as a STRING
ALTER TABLE 
`mydb.classicrock`
ADD COLUMN
genre STRING
;
#Update the genre rocks to all be "Classic Rock"
UPDATE
`mydb.classicrock`
SET genre = "Classic Rock"
WHERE
genre IS NULL
;
CREATE VIEW
mydb.v_listens
AS
SELECT
artist_name,
track_name,
genre,
COUNT(listened_at) AS listens,
COUNT(DISTINCT user_name) AS fans,
MIN(listened_at) AS earliest,
MAX(listened_at) AS latest
FROM
`predictive-keep-397402.mydb.classicrock`
GROUP BY
artist_name,
track_name,
genre
;
SELECT
*
FROM
`predictive-keep-397402.mydb.v_listens`
ORDER BY
listens DESC
LIMIT 10
;

SELECT 
    artist_name,
    SUM(listens) AS totListens,
    ROUND(AVG(CASE WHEN listens >= 100 THEN listens END), 2) AS avgTrackListens,
    ROUND(AVG(CASE WHEN listens >= 100 THEN fans END), 2) AS avgTrackFans
FROM 
    mydb.v_listens
GROUP BY 
    artist_name
ORDER BY 
    avgTrackListens DESC
    ;
-- First part: Totals and averages for each artist
SELECT 
    artist_name AS artist,
    SUM(listens) AS totListens,
    ROUND(AVG(CASE WHEN listens >= 100 THEN fans END), 2) AS avgTrackFans
FROM 
    mydb.v_listens
WHERE 
    listens >= 100
GROUP BY 
    artist_name

UNION ALL

-- Second part: Grand totals
SELECT 
    'GRAND TOTALS' AS artist,
    SUM(listens) AS totListens,
    ROUND(AVG(CASE WHEN listens >= 100 THEN fans END), 2) AS avgTrackFans
FROM 
    mydb.v_listens
WHERE 
    listens >= 100
ORDER BY
totListens DESC
    ;
