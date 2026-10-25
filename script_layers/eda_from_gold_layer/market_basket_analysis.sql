-- Top 15 most frequently co-purchased product pairs
SELECT 
    p1.product_name AS product_a, 
    p2.product_name AS product_b, 
    COUNT(*) AS times_bought_together
FROM gold.fact_order_products fop1
JOIN gold.fact_order_products fop2 
    ON fop1.order_id = fop2.order_id 
    AND fop1.product_id < fop2.product_id   -- avoids duplicate pairs (A,B) and (B,A)
JOIN gold.dim_products p1 ON fop1.product_id = p1.product_id
JOIN gold.dim_products p2 ON fop2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name
ORDER BY times_bought_together DESC
LIMIT 15;