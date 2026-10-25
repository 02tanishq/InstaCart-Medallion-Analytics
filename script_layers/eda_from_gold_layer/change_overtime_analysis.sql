-- Since there's no calendar date, "time" here means order_number sequence 
-- (how a user's behavior changes as their order count grows)

-- Average basket size by order_number (do baskets shrink or grow over a user's lifetime?)
SELECT o.order_number, ROUND(AVG(item_count), 2) AS avg_basket_size
FROM (
    SELECT order_id, order_number, COUNT(*) AS item_count
    FROM gold.fact_order_products
    GROUP BY order_id, order_number
) o
GROUP BY o.order_number
ORDER BY o.order_number
LIMIT 30;

-- Reorder rate trend by order_number (do users reorder more as they order more?)
SELECT order_number,
       ROUND(100.0 * SUM(CASE WHEN reordered THEN 1 ELSE 0 END) / COUNT(*), 2) AS reorder_rate_pct
FROM gold.fact_order_products
GROUP BY order_number
ORDER BY order_number
LIMIT 30;

-- Using LAG() to compare each order's item count to the user's previous order
SELECT 
    order_id, user_id, order_number, item_count,
    LAG(item_count) OVER (PARTITION BY user_id ORDER BY order_number) AS prev_item_count
FROM (
    SELECT fop.order_id, o.user_id, o.order_number, COUNT(*) AS item_count
    FROM gold.fact_order_products fop
    JOIN gold.dim_users o ON fop.user_id = o.user_id  -- adjust join if needed
    GROUP BY fop.order_id, o.user_id, o.order_number
) sub
ORDER BY user_id, order_number
LIMIT 50;