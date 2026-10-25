/* 
====================================================================================
Defining Tables within "gold" Layer using DDL.
Gold implements a star schema: dimension tables surround a central fact table,
denormalized for fast analytical queries with minimal joins. Sourced from silver.
eval_set is dropped here — every row in silver.orders is already 'prior' by this
point, so the column is redundant.
====================================================================================
*/
CREATE SCHEMA IF NOT EXISTS gold;

-- Drop in reverse dependency order (fact before dimensions)
DROP TABLE IF EXISTS gold.fact_order_products;
DROP TABLE IF EXISTS gold.dim_products;
DROP TABLE IF EXISTS gold.dim_users;

-- Dimension: products, denormalized with aisle/department names pre-joined
CREATE TABLE gold.dim_products (
    product_id     INT PRIMARY KEY,
    product_name   TEXT NOT NULL,
    aisle          TEXT,      -- joined in, no need to hit silver.aisles at query time
    department     TEXT       -- joined in, no need to hit silver.departments at query time
);

-- Dimension: users, one row per user with pre-aggregated behavioral stats
CREATE TABLE gold.dim_users (
    user_id                  INT PRIMARY KEY,
    total_orders              INT,
    avg_days_between_orders   NUMERIC
);

-- Fact: one row per product per order (grain = order_id + product_id)
CREATE TABLE gold.fact_order_products (
    order_id                INT,
    product_id               INT REFERENCES gold.dim_products(product_id),
    user_id                  INT REFERENCES gold.dim_users(user_id),
    add_to_cart_order         INT,
    reordered                BOOLEAN,
    order_number              INT,
    order_dow                SMALLINT,
    order_hour_of_day         SMALLINT,
    days_since_prior_order    NUMERIC,   -- NULL = user's first order
    is_first_order            BOOLEAN,
    PRIMARY KEY (order_id, product_id)
);