-- List all tables and their row counts across the gold layer
SELECT 'dim_products' AS table_name, COUNT(*) FROM gold.dim_products
UNION ALL
SELECT 'dim_users', COUNT(*) FROM gold.dim_users
UNION ALL
SELECT 'fact_order_products', COUNT(*) FROM gold.fact_order_products;

-- Inspect column structure of each gold table
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'gold'
ORDER BY table_name, ordinal_position;