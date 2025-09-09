-- Total Sales generated, $23141511.83 and Units of products sold, 3675765
Select sum(total_amt_usd) as Total_Sales, sum(total) as Total_Units_Sold
from orders;


-- Top 10 Sales per company

select  c.name AS company,
       SUM(o.total_amt_usd) AS total_sales_usd
from accounts c
join orders o ON c.id = o.account_id
group by c.name
order by total_sales_usd desc
limit 10;


-- Top Sales Rep by Revenue

select sr.name AS sales_rep,
       r.name AS region,
       SUM(o.total_amt_usd) AS total_sales_usd
from sales_reps sr
join accounts c ON sr.id = c.sales_rep_id
join orders o ON c.id = o.account_id
join region r ON sr.region_id = r.id
group by sr.name, r.name
order by total_sales_usd desc
limit 5;


-- Monthly sales trend

select DATE_TRUNC('month', occurred_at) AS month,
       SUM(total_amt_usd) AS monthly_sales
from orders
group by month
order by month;


-- Most effective marketing channel

select w.channel,
       COUNT(*) AS total_events,
       COUNT(DISTINCT w.account_id) AS unique_accounts
from web_events w
group by w.channel
order by total_events DESC;


-- Sales by region

select r.name AS region,
       SUM(o.total_amt_usd) AS total_sales
from region r
join sales_reps sr ON r.id = sr.region_id
join accounts c ON sr.id = c.sales_rep_id
join orders o ON c.id = o.account_id
group by  r.name
order by total_sales DESC;


-- year 2016, had the highest sales of $12864917.92 and lowest was 2017
-- Yearly total sales grow substantially through 2016, then taper in 2017
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


-- Accounts with web events vs orders
SELECT
    a.name,
    COUNT(DISTINCT we.id) AS web_events,
    COUNT(DISTINCT o.id) AS orders
FROM
    accounts a
    LEFT JOIN web_events we ON a.id = we.account_id
    LEFT JOIN orders o ON a.id = o.account_id
GROUP BY
    a.name;


-- Top 10 accounts by number of orders
SELECT
    a.name,
    COUNT(o.id) AS order_count
FROM
    accounts a
    JOIN orders o ON a.id = o.account_id
GROUP BY
    a.name
ORDER BY
    order_count DESC
LIMIT 10;


-- Accounts with no orders but with web activity
SELECT
    a.name,
    COUNT(we.id) AS web_events
FROM
    accounts a
    LEFT JOIN orders o ON a.id = o.account_id
    JOIN web_events we ON a.id = we.account_id
WHERE
    o.id IS NULL
GROUP BY
    a.name
ORDER BY
    web_events DESC;


-- Average revenue per account
SELECT
    a.name,
    AVG(o.total_amt_usd) AS avg_revenue
FROM
    accounts a
JOIN
    orders o ON a.id = o.account_id
GROUP BY
    a.name
ORDER BY
    avg_revenue DESC;

-- Revenue contribution by product type
SELECT 'standard' AS product, SUM(standard_amt_usd) AS revenue FROM orders
UNION ALL
SELECT 'gloss', SUM(gloss_amt_usd) AS revenue FROM orders
UNION ALL
SELECT 'poster', SUM(poster_amt_usd) AS revenue FROM orders;


-- Hour of day with highest web engagement
SELECT
    EXTRACT(HOUR FROM occurred_at) AS hour,
    COUNT(*) AS events
FROM
    web_events
GROUP BY
    hour
ORDER BY
    events DESC;


-- Revenue from web by account
SELECT
    a.name,
    COUNT(DISTINCT we.id) AS web_events,
    SUM(o.total_amt_usd) AS total_revenue
FROM
    accounts a
    LEFT JOIN web_events we ON a.id = we.account_id
    LEFT JOIN orders o ON a.id = o.account_id
GROUP BY
    a.name
ORDER BY
    total_revenue DESC;