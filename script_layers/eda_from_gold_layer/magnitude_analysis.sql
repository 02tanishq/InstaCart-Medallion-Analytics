-- Total orders by department (which departments drive the most volume)
SELECT dp.department, COUNT(*) AS total_line_items
FROM gold.fact_order_products fop
JOIN gold.dim_products dp ON fop.product_id = dp.product_id
GROUP BY dp.department
ORDER BY total_line_items DESC;

-- Total orders by day of week
SELECT order_dow, COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_order_products
GROUP BY order_dow
ORDER BY total_orders DESC;

-- Total orders by user order-sequence position (are most orders early or late in a user's history?)
SELECT order_number, COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_order_products
GROUP BY order_number
ORDER BY order_number
LIMIT 20;