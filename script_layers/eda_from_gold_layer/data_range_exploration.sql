-- This dataset has no real calendar dates — order_number is the closest 
-- proxy for "time" (sequence of a user's orders), so we explore its range instead

-- Range of order_number across all users (how deep does order history go?)
SELECT MIN(order_number) AS min_order_number, MAX(order_number) AS max_order_number
FROM gold.fact_order_products;

-- Range of days_since_prior_order (excludes first orders, which are NULL)
SELECT MIN(days_since_prior_order) AS min_gap, MAX(days_since_prior_order) AS max_gap,
       AVG(days_since_prior_order) AS avg_gap
FROM gold.fact_order_products
WHERE days_since_prior_order IS NOT NULL;

-- Distribution of order_dow (0-6) — which days see the most orders
SELECT order_dow, COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_order_products
GROUP BY order_dow
ORDER BY order_dow;

-- Distribution of order_hour_of_day (0-23) — peak ordering hours
SELECT order_hour_of_day, COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_order_products
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day;