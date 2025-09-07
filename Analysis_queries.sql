-- Total Sales generated, $23141511.83
Select sum(total_amt_usd) as Total_Sales from orders;



-- year 2016, had the highest sales of $12864917.92 and lowest was 2017
SELECT DATE_PART('year', occurred_at) AS year,
SUM(total_amt_usd) AS total_sales
FROM orders
GROUP BY DATE_PART('year', occurred_at)
ORDER BY total_sales DESC;



--Generally, December was the highest sales with $3129411.98 and February the lowest
SELECT TO_CHAR(occurred_at, 'Month') AS Month,
SUM(total_amt_usd) AS total_sales
FROM orders
GROUP BY TO_CHAR(occurred_at, 'Month')
ORDER BY total_sales DESC;



--Highest Selling Region
SELECT r.name,
SUM(o.total_amt_usd) AS total_sales
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps sr ON a.sales_rep_id = sr.id
JOIN region r ON sr.region_id = r.id
GROUP BY r.name
ORDER BY total_sales DESC;


