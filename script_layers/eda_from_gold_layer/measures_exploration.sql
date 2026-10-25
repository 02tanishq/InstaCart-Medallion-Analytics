-- Core business measures at a glance

SELECT COUNT(DISTINCT order_id) AS total_orders FROM gold.fact_order_products;
SELECT COUNT(DISTINCT user_id) AS total_users FROM gold.fact_order_products;
SELECT COUNT(DISTINCT product_id) AS total_products_ordered FROM gold.fact_order_products;
SELECT COUNT(*) AS total_line_items FROM gold.fact_order_products;

-- Average basket size (items per order)
SELECT ROUND(AVG(item_count), 2) AS avg_basket_size
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM gold.fact_order_products
    GROUP BY order_id
) AS basket_sizes;

-- Overall reorder rate across all line items
SELECT 
    ROUND(100.0 * SUM(CASE WHEN reordered THEN 1 ELSE 0 END) / COUNT(*), 2) AS reorder_rate_pct
FROM gold.fact_order_products;