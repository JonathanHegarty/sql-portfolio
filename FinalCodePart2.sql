#Q1- According to this table how many countries only have one airport?
SELECT
air.country,
COUNT(air.object_id) AS counti
FROM
`bigquery-public-data.faa.us_airports` AS air
GROUP BY
air.country
HAVING
counti = 1
;
#Q2-What were the average quarterly price indexes (rounded to two decimal places) for 2018?
SELECT
ROUND(AVG(emp.value),2) AS index
FROM
`bigquery-public-data.bls.employment_hours_earnings` AS emp
WHERE
emp.period IN("M10","M11","M12")
;
#Q3- Which months had an average monthly air temperature greater than the overall average air temperature?
SELECT
ice.month,
ROUND(AVG(ice.air_temperature),2) AS moAvgTemp,
(SELECT
ROUND(AVG(ice.air_temperature),2)
FROM
`bigquery-public-data.noaa_icoads.icoads_core_2015` AS ice
) ovAvgTemp
FROM
`bigquery-public-data.noaa_icoads.icoads_core_2015` AS ice
GROUP BY
ice.month
HAVING
moAvgTemp > ovAvgTemp
ORDER BY
moAvgTemp DESC
;
#Q4-What were the grand totals and sub totals for the Top5HitterParks and Other Parks?
SELECT
COALESCE(CASE WHEN games.venueName IN("Rogers Centre","Coors Field","Fenway Park","Great American Ball Park","Angel Stadium of Anaheim") THEN "Top5HitPark" ELSE "Other" END, "Grand Total") AS parkType,
games.venueName,
SUM(games.homeFinalRuns+games.awayFinalRuns) AS runs,
SUM(games.homeFinalHits+games.awayFinalHits) AS hits,
ROUND(SUM(games.homeFinalRuns+games.awayFinalRuns)/SUM(games.homeFinalHits+games.awayFinalHits),2) AS ratio
FROM
`bigquery-public-data.baseball.games_wide` AS games
GROUP BY
ROLLUP(
games.venueName
)
ORDER BY
hits DESC
;
#Q5-In which venue were the least amount of hits recorded?
SELECT
games.venueName,
SUM(games.homeFinalRuns+games.awayFinalRuns) AS runs,
SUM(games.homeFinalHits+games.awayFinalHits) AS hits,
ROUND(SUM(games.homeFinalRuns+games.awayFinalRuns)/SUM(games.homeFinalHits+games.awayFinalHits),2) AS ratio
FROM
`bigquery-public-data.baseball.games_wide` AS games
GROUP BY
games.venueName
ORDER BY
hits
