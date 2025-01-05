--Question 1:
-- How many refunds were there for each month in 2021? What about each quarter and week?

-- Clarify: So it sounds like you want me to return the count of refunds in each month, quarter, and week in 2021 is that correct?

SELECT DATE_TRUNC(refund_ts, week) AS weekly_refunds -- Resulting query includes 2020-12-27 (this is incorrect)
  -- DATE_TRUNC(refund_ts, month) AS monthly_refunds
  -- DATE_TRUNC(refund_ts, quarter) AS quarterly_refunds
  ,COUNT(refund_ts) AS refunds
FROM core.order_status
WHERE EXTRACT(year FROM refund_ts) = 2021 
GROUP BY 1
ORDER BY 1 ASC; 


-- Grouping by Month

SELECT --DATE_TRUNC(refund_ts, week) AS weekly_refunds -- Resulting query includes 2020-12-27 (this is incorrect)
  DATE_TRUNC(refund_ts, month) AS monthly_refunds
  -- DATE_TRUNC(refund_ts, quarter) AS quarterly_refunds
  ,COUNT(refund_ts) AS refunds
FROM core.order_status
WHERE EXTRACT(year FROM refund_ts) = 2021 
GROUP BY 1
ORDER BY 1 ASC; 

-- Grouping by Quarter

SELECT --DATE_TRUNC(refund_ts, week) AS weekly_refunds -- Resulting query includes 2020-12-27 (this is incorrect)
  -- DATE_TRUNC(refund_ts, month) AS monthly_refunds
  DATE_TRUNC(refund_ts, quarter) AS quarterly_refunds
  ,COUNT(refund_ts) AS refunds
FROM core.order_status
WHERE EXTRACT(year FROM refund_ts) = 2021 
GROUP BY 1
ORDER BY 1 ASC; 

--Question 2: 
-- For each region, what’s the total number of customers and the total number of orders? Sort alphabetically by region.

-- Clarify: It sounds like you want me to group by region and count the number of customers and orders, sorting alphabetically

-- It also sounds like we will be doing a join of all the tables to create a connection between the orders and the region

SELECT region
  , COUNT(DISTINCT customers.id) AS customer_count
  , COUNT(DISTINCT orders.id) AS order_count
FROM core.orders
LEFT JOIN core.customers
  ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
  ON customers.country_code = geo_lookup.country_code
GROUP BY 1
ORDER BY 1 DESC;

--Question 3:
-- What’s the average time to deliver for each purchase platform? 

-- Clarify: For the average time to deliver, do you want the amount of days between purchase and delivery? and filtered by purchase platform?

SELECT purchase_platform
  , ROUND(AVG(DATE_DIFF(delivery_ts, orders.purchase_ts, day)),4) AS average_delivery
FROM core.orders
LEFT JOIN core.order_status
  ON orders.id = order_status.order_id
GROUP BY 1;

--Question 4:
-- What were the top 2 regions for Macbook sales in 2020? 

-- Clarify, by top do you mean most number of purchases?

-- It sounds like we also need to join the geo_lookup table onto orders.

SELECT geo_lookup.region
  , ROUND(SUM(orders.usd_price),2) AS total_sales
FROM core.orders
LEFT JOIN core.customers -- Customers joins on orders
  ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
  ON customers.country_code = geo_lookup.country_code
WHERE LOWER(orders.product_name) LIKE '%macbook%'
  AND EXTRACT(year FROM purchase_ts) = 2020 -- no order status needed.
GROUP BY 1
ORDER BY 2 DESC
LIMIT 2;

-- attempt 1, we had a null result (do not need to join order_status on orders)
