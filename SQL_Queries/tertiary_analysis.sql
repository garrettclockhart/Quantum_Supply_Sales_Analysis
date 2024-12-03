-- Question 1:
-- What were the order counts, sales, and AOV for Macbooks sold in North America for each quarter across all years? 

# COUNT of orders, sales, and AOV for all macbook sales in North America per quarter. 
# Join geolookup to customers and customers to orders
# time frame all years per quarter

SELECT DATE_TRUNC(orders.purchase_ts, quarter) AS purchase_quarter
  , COUNT(DISTINCT orders.id) AS order_count
  , ROUND(SUM(orders.usd_price),2) AS sales
  , ROUND(AVG(orders.usd_price),2) AS aov
FROM core.orders
LEFT JOIN core.customers
  ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
  ON customers.country_code = geo_lookup.country_code
WHERE LOWER(orders.product_name) LIKE '%macbook%'
  AND region = 'NA'
GROUP BY 1
ORDER BY 1 DESC;


-- (BONUS) What is the average quarterly order count and total sales for Macbooks sold in North America? (i.e. “For North America Macbooks, average of X units sold per quarter and Y in dollar sales per quarter”)

WITH quarterly_metrics AS
(SELECT DATE_TRUNC(orders.purchase_ts, quarter) AS purchase_quarter
  , COUNT(DISTINCT orders.id) AS order_count
  , ROUND(SUM(orders.usd_price),2) AS total_sales
  , ROUND(AVG(orders.usd_price),2) AS aov
FROM core.orders
LEFT JOIN core.customers
  ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
  ON customers.country_code = geo_lookup.country_code
WHERE LOWER(orders.product_name) LIKE '%macbook%'
  AND region = 'NA'
GROUP BY 1
ORDER BY 1 DESC)

SELECT ROUND(AVG(order_count),2) AS quarterly_avg
, ROUND(AVG(total_sales),2) AS quarterly_sales
FROM quarterly_metrics; 

-- Question 2:
-- For products purchased in 2022 on the website or products purchased on mobile in any year, which region has the average highest time to deliver?

-- The result will be regions with the highest time to deliver, filtered by products bought in 2022 or on mobile.
-- clarifying question: Do we want the table to be sorted by region by highest time to deliver?

-- Looking at the question, the result we want is the average time to deliver for each country ordered by the highest time to deliver. 

-- Join on the orders table, order_status table, customers, geo_lookup (Not certain if this is the correct order)

SELECT geo_lookup.region
  , ROUND(AVG(DATE_DIFF(order_status.delivery_ts, order_status.purchase_ts, day)),2) AS time_to_deliver
FROM core.order_status
LEFT JOIN core.orders
  ON order_status.order_id = orders.id
LEFT JOIN core.customers
  ON customers.id = orders.customer_id
LEFT JOIN core.geo_lookup
  ON customers.country_code = geo_lookup.country_code
WHERE (EXTRACT(year FROM order_status.purchase_ts) = 2022 
  AND orders.purchase_platform = 'website')
  OR orders.purchase_platform = 'mobile app'
GROUP BY 1
ORDER BY 2 ASC;

-- 

-- Rewrite this query for website purchases made in 2022 or Samsung purchases made in 2021, expressing time to deliver in weeks instead of days.
SELECT geo_lookup.region
  , ROUND(AVG(DATE_DIFF(order_status.delivery_ts, order_status.purchase_ts, week)),2) AS time_to_deliver --changed day to week
FROM core.order_status
LEFT JOIN core.orders
  ON order_status.order_id = orders.id
LEFT JOIN core.customers
  ON customers.id = orders.customer_id
LEFT JOIN core.geo_lookup
  ON customers.country_code = geo_lookup.country_code
WHERE (EXTRACT(year FROM order_status.purchase_ts) = 2022 
  AND orders.purchase_platform = 'website')
  OR (lower(orders.product_name) LIKE '%samsung%'           -- changed purchase_platform to product_name and added extract function for 2021
  AND EXTRACT(year FROM order_status.purchase_ts) = 2021) 
GROUP BY 1
ORDER BY 2 DESC;

--Question 3:
-- What was the refund rate and refund count for each product overall? 

-- Result the product, the refund rate, and the count of refunds for EACH product
-- JOIN orders and orderstatus on id

SELECT CASE WHEN orders.product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE orders.product_name END AS product_clean
  , ROUND((COUNT(order_status.refund_ts)/COUNT(order_status.purchase_ts)),4) AS refund_rate
  , COUNT(order_status.refund_ts) AS refund_count
FROM core.order_status
LEFT JOIN core.orders
ON order_status.order_id = orders.id
GROUP BY 1
ORDER BY 2 DESC;

-- original solution
select case when product_name = '27in"" 4k gaming monitor' then '27in 4K gaming monitor' else product_name end as product_clean,
    sum(case when refund_ts is not null then 1 else 0 end) as refunds,
    avg(case when refund_ts is not null then 1 else 0 end) as refund_rate
from core.orders 
left join core.order_status 
    on orders.id = order_status.order_id
group by 1
order by 3 desc;

-- BONUS What was the refund rate and refund count for each product per year? How would you interpret these rates in English?

SELECT EXTRACT(year FROM order_status.purchase_ts) AS year -- when extracting use correct column, other wise refund_rate gets aggregated as 100% or 0%. ie. refund_ts is incorrect
  ,  CASE WHEN product_name = '27in"" 4k gaming monitor' THEN '27in 4K gaming monitor' ELSE product_name END AS product_clean
  -- , ROUND AS refund_rate
  -- , COUNT(orders.purchase_ts) as purchase_count
  -- , COUNT(order_status.refund_ts) AS refund_count
  , SUM(CASE WHEN refund_ts IS NOT NULL THEN 1 ELSE 0 END) AS refunds
  , ROUND(AVG(CASE WHEN refund_ts IS NOT NULL THEN 1 ELSE 0 END),4) AS refund_rate
FROM core.orders
LEFT JOIN core.order_status
  ON orders.id = order_status.order_id
GROUP BY 1,2
ORDER BY 3 DESC;

-- In plain english, this query is demonstrating the count of refunds and their refund rate for each product druing each year. It shows the number of times a product has been refunded in each year and what percentage of orders end up getting refunded.

--Question 4:
-- Within each region, what is the most popular product? 

-- Clarify: In this question we are going to use order count as a definition for most popular

WITH sales_by_product AS (SELECT region
    , CASE WHEN product_name = '27in"" gaming monitor' THEN '27in gaming monitor' ELSE product_name END AS product_clean 
    , COUNT(DISTINCT orders.id) AS total_orders -- Count the total orders per region (using a cte we will count per product)
FROM core.orders
LEFT JOIN core.customers
    ON customers.id = orders.customer_id
LEFT JOIN core.geo_lookup
    ON customers.country_code = geo_lookup.country_code  -- These joins are connecting the products to a region
GROUP BY 1,2),

ranked_orders AS (
    SELECT *
        , ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_orders DESC) AS order_ranking
    FROM sales_by_product
    ORDER BY 4 ASC) -- This CTE is rank to order the count per product per country.

SELECT *
FROM ranked_orders
WHERE order_ranking = 1;

--Question 5:
-- How does the time to make a purchase differ between loyalty customers vs. non-loyalty customers? 

-- Can I assume the purchase difference should be days or months from the account created_on and the purchase_ts
-- I'll join customers, to orders, to order_status
-- Then I will find the date_diff between account created_on and the purchase_ts in days. as well as a seperate column for months
-- Then I would average the two columns and then group by loyalty member

SELECT customers.loyalty_program
  , ROUND(AVG(DATE_DIFF(order_status.purchase_ts, customers.created_on, day)),1) AS days_to_purchase
  , ROUND(AVG(DATE_DIFF(order_status.purchase_ts, customers.created_on, month)),1) AS months_to_purchase
FROM core.customers
LEFT JOIN core.orders
  ON customers.id = orders.customer_id
LEFT JOIN core.order_status
  ON order_status.order_id = orders.id
GROUP BY 1;

-- BONUS Update this query to split the time to purchase per loyalty program, per purchase platform. Return the number of records to benchmark the severity of nulls.

SELECT orders.purchase_platform
  , customers.loyalty_program
  , ROUND(AVG(DATE_DIFF(order_status.purchase_ts, customers.created_on, day)),1) AS days_to_purchase
  , ROUND(AVG(DATE_DIFF(order_status.purchase_ts, customers.created_on, month)),1) AS months_to_purchase
  , COUNT(*) AS row_number
FROM core.customers
LEFT JOIN core.orders
  ON customers.id = orders.customer_id
LEFT JOIN core.order_status
  ON order_status.order_id = orders.id
GROUP BY 1,2;
