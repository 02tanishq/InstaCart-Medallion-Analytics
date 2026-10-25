-- Running total of orders by department (cumulative volume ranked)
SELECT department, total_line_items,
       SUM(total_line_items) OVER (ORDER BY total_line_items DESC) AS running_total
FROM (
    SELECT dp.department, COUNT(*) AS total_line_items
    FROM gold.fact_order_products fop
    JOIN gold.dim_products dp ON fop.product_id = dp.product_id
    GROUP BY dp.department
) dept_totals
ORDER BY total_line_items DESC;

-- Cumulative distribution of users by total_orders (what % of users are "power users"?)
SELECT total_orders, COUNT(*) AS user_count,
       SUM(COUNT(*)) OVER (ORDER BY total_orders) AS cumulative_users
FROM gold.dim_users
GROUP BY total_orders
ORDER BY total_orders;