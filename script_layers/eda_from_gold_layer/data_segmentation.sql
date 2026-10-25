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