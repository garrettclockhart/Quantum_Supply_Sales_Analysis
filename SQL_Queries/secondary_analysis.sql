--Question 1:
-- For each purchase platform, return the top 3 customers by the number of purchases and order them within that platform. If there is a tie, break the tie using any order. 

-- purchase_platform, followed by the customers_ids with the largest number of purchases as an order_count
-- and then row_number (window function partitioning by platform) and resulting the top 3 customers for each platform
-- no joins

WITH top_customer AS (SELECT purchase_platform
  , customer_id AS customer
  , COUNT(DISTINCT id) AS order_count
FROM core.orders
GROUP BY 1,2), -- this section is all correct

platform_cte AS (
  SELECT *
  ,row_number() OVER (PARTITION BY purchase_platform ORDER BY order_count DESC) AS order_ranks -- this is close, you need to make sure that the we have the ORDER BY in the parentases. This CTE is used to give a rank to the order counts and partitioned by 
FROM top_customer)

SELECT *
FROM platform_cte
WHERE order_ranks <= 3;

--Question 2:
-- What was the most-purchased brand in the APAC region?

-- it sounds like we want the table to result in region and the brand with the highest number of purchases for that brand. 
-- We also need to uniform all the products to have a brand because we do not have a brand column

-- group by used only for the country roll ups.

SELECT CASE WHEN product_name LIKE '%Apple%' or product_name LIKE '%Macbook%'THEN 'Apple' -- Don't need to select region here because of redundancy
  WHEN product_name like 'Samsung%'then 'Samsung'
  WHEN product_name like 'ThinkPad%' then 'ThinkPad'-- add lower before product_name
  WHEN product_name like 'bose%' then 'Bose'
  else 'Unknown' end as brand
  , COUNT(DISTINCT orders.id) AS purchase_count
FROM core.orders
LEFT JOIN core.customers
  ON orders.customer_id = customers.id
LEFT JOIN core.geo_lookup
  USING(country_code)
WHERE region = 'APAC'
GROUP BY 1
ORDER BY 2 DESC -- results in highest order count on top
LIMIT 1; -- limits to the most purchased brand

--Question 3:
-- Of people who bought Apple products, which 5 customers have the top average order value, ranked from highest AOV to lowest AOV? 

-- customers who bought apple products, which 5 customers have the top AOV highest to lowest. 

-- customer_id, AOV columns (order by AOV desc)

-- tables needed orders

SELECT customer_id
  , ROUND(AVG(usd_price),2) AS AOV
FROM core.orders
WHERE LOWER(product_name) LIKE ANY ('%apple%','%macbook%') --IN statement must be explicit when using
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Question 4:
-- (Challenge) Within each purchase platform, what are the top two marketing channels ranked by average order value? 

-- columns purchase_platform, marketing_channels, AOV

-- tables: orders and customers (joined together on id)

-- there are 2 purchase platforms
-- Coalese null values to unknown 
-- 5 marketing channels

--end table should have 2 results for each purchase platform, which are the two highest aov marketing channels. 
-- purchase_platform | marketing_channel | AOV | marketing_channel_rank

-- window function row_number() OVER (partition by marketing_channel order by AOV DESC) AS marketing_channel_rank

WITH purchases AS (
SELECT purchase_platform
  , COALESCE(marketing_channel,'unknown') AS marketing_channel
  , ROUND(AVG(usd_price),2) AS AOV
FROM core.orders
LEFT JOIN core.customers
ON orders.customer_id = customers.id
GROUP BY 1,2
ORDER BY 3 DESC)

SELECT *
  , row_number() OVER (partition by purchase_platform order by AOV DESC) AS marketing_channel_rank
FROM purchases
QUALIFY marketing_channel_rank <= 2;

