# Jonathan Hegarty's portfolio

Welcome! This repository highlights my SQL experience through a variety of queries and projects focused on data analysis, transformation, and optimization.

Each script demonstrates a different skill set, from core query logic and joins to advanced analytical functions and database design concepts.

---

## Repository Overview

| File | Description | Skills Demonstrated |
|------|--------------|--------------------|
| [AlterUnionAddViews.sql](AlterUnionAddViews.sql) | Demonstrates creating and altering views, using `UNION` operations to merge datasets efficiently. 
| [CaseRollupCoalesce.sql](CaseRollupCoalesce.sql) | Shows use of `CASE`, `ROLLUP`, and `COALESCE` for handling nulls and generating subtotals.
| [FinalCode1.sql](FinalCode1.sql) | Part 1 of a full analytical workflow — data cleaning, joins, and transformations.
| [FinalCodePart2.sql](FinalCodePart2.sql) | Part 2: advanced analysis and final reporting queries.

---

## Example Snippet

Here’s a short example of my SQL style and formatting:

```sql
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
