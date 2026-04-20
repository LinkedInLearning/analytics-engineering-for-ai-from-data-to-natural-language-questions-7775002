-- =============================================================================
-- Semantic Layer Validation Queries
-- dbt tests cover column quality (nulls, uniqueness, relationships).
-- These queries cover what dbt tests cannot: business KPIs and cross-model
-- consistency. Run each block independently in DBeaver.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- METRICS: confirm each aggregation resolves against real data
-- Expected: all three columns return positive numbers; avg_order_value and
-- manual_check must match
-- -----------------------------------------------------------------------------
SELECT
    SUM(REVENUE)                              AS total_revenue,
    COUNT(ORDER_ID)                           AS order_count,
    ROUND(AVG(REVENUE), 2)                    AS avg_order_value,
    ROUND(SUM(REVENUE) / COUNT(ORDER_ID), 2)  AS manual_check  -- must equal avg_order_value
FROM main_marts.fct_orders;


-- -----------------------------------------------------------------------------
-- CROSS-CHECK: revenue consistency between fct_orders and dim_customers
-- Expected: gap must be 0 — both models must agree on total revenue
-- -----------------------------------------------------------------------------
SELECT
    ROUND(SUM(f.REVENUE), 2)                  AS revenue_from_fact,
    ROUND(SUM(c.CUSTOMER_LIFETIME_VALUE), 2)  AS revenue_from_dim,
    ROUND(SUM(f.REVENUE) - SUM(c.CUSTOMER_LIFETIME_VALUE), 2) AS gap  -- must be 0
FROM main_marts.fct_orders f
CROSS JOIN (SELECT SUM(CUSTOMER_LIFETIME_VALUE) FROM main_marts.dim_customers) c(clv_total);


-- -----------------------------------------------------------------------------
-- DIMENSIONS: inventory of values the AI will encounter
-- Expected: no nulls, no surprise values — update semantic_layer.yml
-- descriptions if you find values not already documented there
-- -----------------------------------------------------------------------------
SELECT 'CATEGORY'     AS dimension, CATEGORY     AS value, COUNT(*) AS orders FROM main_marts.fct_orders GROUP BY CATEGORY
UNION ALL
SELECT 'BRAND_NAME'   AS dimension, BRAND_NAME   AS value, COUNT(*) AS orders FROM main_marts.fct_orders GROUP BY BRAND_NAME
UNION ALL
SELECT 'COUNTRY_CODE' AS dimension, COUNTRY_CODE AS value, COUNT(*) AS orders FROM main_marts.fct_orders GROUP BY COUNTRY_CODE
ORDER BY dimension, orders DESC;
