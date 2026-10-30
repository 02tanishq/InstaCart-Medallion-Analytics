# 🛒 Instacart Medallion Analytics: Modern Lakehouse & Star-Schema Data Warehouse

[![Database: PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-336791.svg?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Architecture: Medallion](https://img.shields.io/badge/Architecture-Medallion%20(Bronze%20%E2%86%92%20Silver%20%E2%86%92%20Gold)-orange.svg)]()
[![Model: Star Schema](https://img.shields.io/badge/Modeling-Star%20Schema%20(Kimball)-blue.svg)]()
[![Analytics: Advanced SQL](https://img.shields.io/badge/Analytics-Window%20Functions%20%26%20CTEs-green.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

An enterprise-grade, end-to-end data warehousing and dimensional modeling solution implementing the **Medallion Architecture (Bronze $\rightarrow$ Silver $\rightarrow$ Gold)** on the Instacart relational transactional dataset (3.4M+ orders, 33M+ product order records). 

Built to simulate modern production data platforms, this project demonstrates automated data ingestion, progressive data hygiene and normalization, automated validation check suites for audit readiness, and advanced SQL analytics (Market Basket co-purchasing, customer cohort segmentation, and cumulative window functions).

---

## 🏗️ Architecture & Data Lineage

The warehouse follows the industry-standard **Medallion Lakehouse Architecture**, segregating data into three distinct quality and refinement zones within PostgreSQL:

```mermaid
flowchart TD
    RAW["Raw Source Data\n(CSVs: Orders, Products, Aisles, Departments)"] -->|Schema-on-Read DDL| BRONZE

    subgraph BRONZE_LAYER ["1. Bronze Layer (Raw Ingestion)"]
        BRONZE["bronze.orders\nbronze.order_products\nbronze.products\nbronze.aisles\nbronze.departments"]
        B_CHECK["Validation: bronze_validation_checks.sql\n• Ingestion completeness\n• Row counts & schema parity"]
        BRONZE -.-> B_CHECK
    end

    BRONZE -->|Cleansing, Type Casting & Deduplication| SILVER

    subgraph SILVER_LAYER ["2. Silver Layer (Cleaned & Normalized)"]
        SILVER["silver.orders\nsilver.order_products\nsilver.products\nsilver.aisles\nsilver.departments"]
        S_CHECK["Validation: silver_validation_checks.sql\n• Orphan foreign keys\n• Boundary checks (days_since_prior)\n• Nullability & uniqueness constraints"]
        SILVER -.-> S_CHECK
    end

    SILVER -->|Dimensional Modeling & Denormalization| GOLD

    subgraph GOLD_LAYER ["3. Gold Layer (Kimball Star Schema)"]
        FACT["gold.fact_order_products\n(Granularity: Order-Item Level)"]
        DIM1["gold.dim_products"]
        DIM2["gold.dim_users"]
        DIM3["gold.dim_orders"]
        DIM4["gold.dim_aisles"]
        DIM5["gold.dim_departments"]

        DIM1 --- FACT
        DIM2 --- FACT
        DIM3 --- FACT
        DIM4 --- FACT
        DIM5 --- FACT
    end

    GOLD --> BI["Advanced SQL Analytics Mart (eda_from_gold_layer/)"]
    BI --> MBA["Market Basket Affinity (Self-Joins)"]
    BI --> SEG["Customer Segmentation & RFM Tiers"]
    BI --> CUM["Cumulative GMV & Window Functions"]
    BI --> TREND["Day/Hour Reorder Velocity & MoM Trends"]
