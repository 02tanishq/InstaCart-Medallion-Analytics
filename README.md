# Load raw CSVs into bronze schema (via psql \copy)
# Example: \copy bronze.orders FROM 'datasets/orders.csv' WITH (FORMAT csv, HEADER true);
# Execute bronze ingestion validation
psql -U postgres -d instacart_medallion -f validation_checks/bronze_validation_checks.sql
```
### Step 3: Transform & Gate the Silver Layer
```bash
# Define clean silver schema
psql -U postgres -d instacart_medallion -f script_layers/silver/silver_ddl.sql
# Run cleansing, normalization, and typing ETL
psql -U postgres -d instacart_medallion -f script_layers/silver/load_silver.sql
# Execute rigorous data quality gate
psql -U postgres -d instacart_medallion -f validation_checks/silver_validation_checks.sql
```
### Step 4: Populate Gold Star Schema & Run Analytics
```bash
# Define fact and dimension tables
psql -U postgres -d instacart_medallion -f script_layers/gold/gold_ddl.sql
# Populate gold star schema
psql -U postgres -d instacart_medallion -f script_layers/gold/load_gold.sql
# Execute Market Basket Analysis
psql -U postgres -d instacart_medallion -f script_layers/eda_from_gold_layer/market_basket_analysis.sql
```
---
## 💼 7. Interview & Resume Talking Points
- **Why Medallion Architecture over a single staging table?**
  > *"Separating data into Bronze, Silver, and Gold ensures strict decoupling: raw data is preserved as immutable history (Bronze), business rules and data standardization are centralized (Silver), and analytical models are isolated for high query velocity (Gold). If business logic changes, we can re-derive the Gold layer without re-ingesting raw sources."*
- **How do you guarantee data quality for non-technical auditors?**
  > *"I implemented pre-promotion validation check suites (`silver_validation_checks.sql`) executing structural assertions: referential integrity tests, boundary constraints ($0 \le \text{gap} \le 30$), and primary-key uniqueness before records enter the Gold layer. This guarantees full code lineage and formal evidence readiness."*
- **How does Star-Schema modeling accelerate query performance?**
  > *"By denormalizing product hierarchies into `gold.dim_products` and user metrics into `gold.dim_users`, analytical queries only need single-hop joins to `gold.fact_order_products`. This eliminates expensive multi-table snowflake joins, drastically improving index utilization on high-volume aggregation queries."*
