#Question 1: What is the total customer revenue per invoice?
SELECT
COALESCE(cus.CUS_LNAME,"Grand Total") AS name,
COALESCE(CAST(inv.INV_NUMBER AS STRING),"Cust Total") AS invoice,
ROUND(SUM(line.LINE_PRICE*line.LINE_UNITS),2) AS revenue
FROM
SaleCo.line AS line
INNER JOIN
SaleCo.invoice AS inv
ON
line.INV_NUMBER = inv.INV_NUMBER
INNER JOIN
SaleCo.customer AS cus
ON
inv.CUS_CODE = cus.CUS_CODE
GROUP BY
ROLLUP
(
  cus.CUS_LNAME,
  inv.INV_NUMBER
)
ORDER BY
revenue DESC,
cus.CUS_LNAME 
;
#Question 2: What is the average product discount (P_DISCOUNT) for each Vendor?
SELECT
ven.v_code,
ven.V_NAME,
ROUND(AVG(prod.P_DISCOUNT),2) AS avgDisc
FROM
SaleCo.product AS prod
LEFT JOIN
SaleCo.vendor AS ven
ON
ven.V_CODE = prod.V_CODE
GROUP BY
ven.V_code,
ven.v_name
ORDER BY
avgDisc DESC,
ven.V_NAME
;
#Question 3: What were the assignment charges for each employee as well as the running total assignment charges?
SELECT
emp.EMP_NUM,
emp.EMP_LNAME,
ass.ASSIGN_NUM,
ass.ASSIGN_CHARGE,
ROUND(SUM(assign_charge) OVER (PARTITION BY ass.EMP_NUM),2)
AS emp_subtotal,
ROUND(SUM(ass.ASSIGN_CHARGE)
OVER(
  ORDER BY ass.EMP_NUM, ass.ASSIGN_NUM
),2) AS assign_chg_running_total
FROM
ConstructCo.employee AS emp
INNER JOIN
ConstructCo.assignment AS ass
ON
emp.EMP_NUM = ass.EMP_NUM
GROUP BY
emp.EMP_NUM,
emp.EMP_LNAME,
ass.ASSIGN_NUM,
ass.ASSIGN_CHARGE,
ass.EMP_NUM
ORDER BY
ass.EMP_NUM,
ass.ASSIGN_NUM
;
