-- All distinct departments (business categories in scope)
SELECT DISTINCT department FROM gold.dim_products ORDER BY department;

-- All distinct aisles per department, to understand catalog structure
SELECT DISTINCT department, aisle 
FROM gold.dim_products 
ORDER BY department, aisle;

-- How many products exist per department
SELECT department, COUNT(*) AS product_count
FROM gold.dim_products
GROUP BY department
ORDER BY product_count DESC;

-- How many aisles exist per department
SELECT department, COUNT(DISTINCT aisle) AS aisle_count
FROM gold.dim_products
GROUP BY department
ORDER BY aisle_count DESC;