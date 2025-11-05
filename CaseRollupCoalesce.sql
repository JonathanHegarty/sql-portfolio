SELECT
order_num,
order_item,
quantity,
CASE
  WHEN quantity >= 100 THEN "High"
  WHEN quantity < 100 THEN "Low"
  END AS qty_flag
FROM
`predictive-keep-397402.styssql.order_items`
;
SELECT
SUM(CASE WHEN quantity >= 100 THEN 1 ELSE 0 END) AS high_count,
SUM(CASE WHEN quantity< 100 THEN 1 ELSE 0 END) AS low_count
FROM
  `predictive-keep-397402.styssql.order_items`
;
SELECT
COUNT(CASE WHEN quantity >= 100 THEN order_item ELSE NULL END) AS high_count,
COUNT(CASE WHEN quantity < 100 THEN order_item ELSE NULL END) AS low_count
FROM
`predictive-keep-397402.styssql.order_items`
;
SELECT
ordi.order_num,
ordi.order_item,
SUM(ordi.quantity) AS tot_qty
FROM
`predictive-keep-397402.styssql.order_items` AS ordi
GROUP BY
ROLLUP(
order_num,
order_item
)
ORDER BY
order_num,
order_item
;
#Clean up of last query to show more clearly grand total and order total
SELECT
COALESCE(CAST(ordi.order_num AS STRING), "grand_total") AS ord_num,
COALESCE(CAST(ordi.order_item AS STRING), "order_total") AS order_total,
SUM(ordi.quantity) AS tot_qty
FROM
`predictive-keep-397402.styssql.order_items` AS ordi
GROUP BY
ROLLUP(
order_num,
order_item
)
ORDER BY
order_num,
order_item
