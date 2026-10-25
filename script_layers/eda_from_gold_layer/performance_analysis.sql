-- Compare each department's reorder rate against the overall average (over/underperforming)
WITH dept_reorder AS (
    SELECT dp.department,
           ROUND(100.0 * SUM(CASE WHEN fop.reordered THEN 1 ELSE 0 END) / COUNT(*), 2) AS dept_reorder_rate
    FROM gold.fact_order_products fop
    JOIN gold.dim_products dp ON fop.product_id = dp.product_id
    GROUP BY dp.department
),
overall AS (
    SELECT ROUND(100.0 * SUM(CASE WHEN reordered THEN 1 ELSE 0 END) / COUNT(*), 2) AS overall_rate
    FROM gold.fact_order_products
)
SELECT dr.department, dr.dept_reorder_rate, o.overall_rate,
       ROUND(dr.dept_reorder_rate - o.overall_rate, 2) AS variance_from_avg
FROM dept_reorder dr, overall o
ORDER BY variance_from_avg DESC;

-- Average add_to_cart_order position per product (what tends to get grabbed first — impulse vs planned)
SELECT dp.product_name, ROUND(AVG(fop.add_to_cart_order), 2) AS avg_cart_position
FROM gold.fact_order_products fop
JOIN gold.dim_products dp ON fop.product_id = dp.product_id
GROUP BY dp.product_name
HAVING COUNT(*) >= 100
ORDER BY avg_cart_position ASC
LIMIT 10;

-- Each department's share of total order volume
SELECT dp.department, COUNT(*) AS total_line_items,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM gold.fact_order_products fop
JOIN gold.dim_products dp ON fop.product_id = dp.product_id
GROUP BY dp.department
ORDER BY pct_of_total DESC;

-- Each day of week's share of total orders
SELECT order_dow, COUNT(DISTINCT order_id) AS total_orders,
       ROUND(100.0 * COUNT(DISTINCT order_id) / SUM(COUNT(DISTINCT order_id)) OVER (), 2) AS pct_of_total
FROM gold.fact_order_products
GROUP BY order_dow
ORDER BY pct_of_total DESC;