/* 
====================================================================================
Loading Tables within "gold" Layer.
Sources: silver.* tables. Applies final denormalization (joining aisle/department
names into products) and drops eval_set, since every silver.orders row is already
'prior' by this point.
====================================================================================
*/

-- Load dim_products: join in aisle and department names, no need for lookups at query time
INSERT INTO gold.dim_products
SELECT
    p.product_id,
    p.product_name,
    a.aisle,
    d.department
FROM silver.products p
JOIN silver.aisles a ON p.aisle_id = a.aisle_id
JOIN silver.departments d ON p.department_id = d.department_id;

-- Load dim_users: straight pass-through from the pre-aggregated silver.users table
INSERT INTO gold.dim_users
SELECT
    user_id,
    total_orders,
    avg_days_between_orders
FROM silver.users;

-- Load fact_order_products: one row per product per order, joined to bring in order-level attributes
INSERT INTO gold.fact_order_products
SELECT
    op.order_id,
    op.product_id,
    o.user_id,
    op.add_to_cart_order,
    op.reordered,
    o.order_number,
    o.order_dow,
    o.order_hour_of_day,
    o.days_since_prior_order,
    o.is_first_order
FROM silver.order_products op
JOIN silver.orders o ON op.order_id = o.order_id;