-- Top 10 most frequently ordered products
SELECT dp.product_name, COUNT(*) AS times_ordered
FROM gold.fact_order_products fop
JOIN gold.dim_products dp ON fop.product_id = dp.product_id
GROUP BY dp.product_name
ORDER BY times_ordered DESC
LIMIT 10;

-- Top 10 most reordered products (by reorder rate, min 100 orders to avoid tiny-sample noise)
SELECT 
    dp.product_name,
    COUNT(*) AS times_ordered,
    SUM(CASE WHEN fop.reordered THEN 1 ELSE 0 END) AS times_reordered,
    ROUND(100.0 * SUM(CASE WHEN fop.reordered THEN 1 ELSE 0 END) / COUNT(*), 2) AS reorder_rate_pct
FROM gold.fact_order_products fop
JOIN gold.dim_products dp ON fop.product_id = dp.product_id
GROUP BY dp.product_name
HAVING COUNT(*) >= 100
ORDER BY reorder_rate_pct DESC
LIMIT 10;

-- Top 5 aisles by order volume
SELECT dp.aisle, COUNT(*) AS total_line_items
FROM gold.fact_order_products fop
JOIN gold.dim_products dp ON fop.product_id = dp.product_id
GROUP BY dp.aisle
ORDER BY total_line_items DESC
LIMIT 5;

-- Bottom 5 departments by order volume (least popular)
SELECT dp.department, COUNT(*) AS total_line_items
FROM gold.fact_order_products fop
JOIN gold.dim_products dp ON fop.product_id = dp.product_id
GROUP BY dp.department
ORDER BY total_line_items ASC
LIMIT 5;

-- Rank users by total order count using window function
SELECT user_id, total_orders,
       RANK() OVER (ORDER BY total_orders DESC) AS user_rank
FROM gold.dim_users
LIMIT 20;