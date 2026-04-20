-- =============================================================================
-- Semantic Layer Validation Queries
-- Run each block independently in DBeaver or your SQL client.
-- Every query should return a result that matches the expected comment.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- METRIC: total_revenue
-- Expected: a single positive number
-- -----------------------------------------------------------------------------
SELECT
    SUM(REVENUE) AS total_revenue
FROM {{ ref('fct_orders') }};


-- -----------------------------------------------------------------------------
-- METRIC: order_count
-- Expected: row count equals COUNT(DISTINCT ORDER_ID) — confirms no duplicates
-- -----------------------------------------------------------------------------
SELECT
    COUNT(ORDER_ID)          AS order_count,
    COUNT(DISTINCT ORDER_ID) AS distinct_orders,
    COUNT(ORDER_ID) - COUNT(DISTINCT ORDER_ID) AS duplicates  -- must be 0
FROM {{ ref('fct_orders') }};


-- -----------------------------------------------------------------------------
-- METRIC: avg_order_value
-- Expected: avg_order_value = total_revenue / order_count (within rounding)
-- -----------------------------------------------------------------------------
SELECT
    AVG(REVENUE)                                    AS avg_order_value,
    ROUND(SUM(REVENUE) / COUNT(ORDER_ID), 2)        AS manual_check  -- must match
FROM {{ ref('fct_orders') }};


-- -----------------------------------------------------------------------------
-- METRIC: total_customers
-- Expected: total_customers <= row count in dim_customers (some may have no orders)
-- -----------------------------------------------------------------------------
SELECT
    COUNT(DISTINCT o.CUSTOMER_ID)  AS customers_with_orders,
    COUNT(c.CUSTOMER_ID)           AS total_customers_in_dim,
    COUNT(c.CUSTOMER_ID) - COUNT(DISTINCT o.CUSTOMER_ID) AS customers_without_orders
FROM {{ ref('fct_orders') }} o
FULL OUTER JOIN {{ ref('dim_customers') }} c ON o.CUSTOMER_ID = c.CUSTOMER_ID;


-- -----------------------------------------------------------------------------
-- METRIC: avg_customer_lifetime_value
-- Expected: matches SUM(REVENUE) / COUNT(DISTINCT CUSTOMER_ID) from fct_orders
-- -----------------------------------------------------------------------------
SELECT
    AVG(CUSTOMER_LIFETIME_VALUE)                          AS avg_clv_from_dim,
    ROUND(SUM(REVENUE) / COUNT(DISTINCT CUSTOMER_ID), 2)  AS avg_clv_from_fact  -- must be close
FROM {{ ref('dim_customers') }}
CROSS JOIN (SELECT SUM(REVENUE) AS rev, COUNT(DISTINCT CUSTOMER_ID) AS custs FROM {{ ref('fct_orders') }}) t;


-- -----------------------------------------------------------------------------
-- DIMENSION: ORDER_DATE
-- Expected: no nulls, date range looks realistic
-- -----------------------------------------------------------------------------
SELECT
    COUNT(*)                          AS total_orders,
    COUNT(ORDER_DATE)                 AS non_null_dates,
    COUNT(*) - COUNT(ORDER_DATE)      AS null_dates,  -- must be 0
    MIN(ORDER_DATE)                   AS earliest_order,
    MAX(ORDER_DATE)                   AS latest_order
FROM {{ ref('fct_orders') }};


-- -----------------------------------------------------------------------------
-- DIMENSION: ORDER_STATUS
-- Expected: only known values — no surprises
-- -----------------------------------------------------------------------------
SELECT
    ORDER_STATUS,
    COUNT(*) AS order_count
FROM {{ ref('fct_orders') }}
GROUP BY ORDER_STATUS
ORDER BY order_count DESC;


-- -----------------------------------------------------------------------------
-- DIMENSION: CUSTOMER_SEGMENT
-- Expected: exactly three values — consumer, corporate, small_business
-- -----------------------------------------------------------------------------
SELECT
    CUSTOMER_SEGMENT,
    COUNT(*) AS order_count
FROM {{ ref('fct_orders') }}
GROUP BY CUSTOMER_SEGMENT
ORDER BY order_count DESC;


-- -----------------------------------------------------------------------------
-- DIMENSION: COUNTRY_CODE
-- Expected: no nulls, plausible set of country codes
-- -----------------------------------------------------------------------------
SELECT
    COUNTRY_CODE,
    COUNT(*) AS order_count
FROM {{ ref('fct_orders') }}
GROUP BY COUNTRY_CODE
ORDER BY order_count DESC;


-- -----------------------------------------------------------------------------
-- DIMENSION: CATEGORY
-- Expected: no nulls, recognisable product categories
-- -----------------------------------------------------------------------------
SELECT
    CATEGORY,
    COUNT(*) AS order_count
FROM {{ ref('fct_orders') }}
GROUP BY CATEGORY
ORDER BY order_count DESC;


-- -----------------------------------------------------------------------------
-- DIMENSION: BRAND_NAME
-- Expected: no nulls, no rogue values
-- -----------------------------------------------------------------------------
SELECT
    BRAND_NAME,
    COUNT(*) AS order_count
FROM {{ ref('fct_orders') }}
GROUP BY BRAND_NAME
ORDER BY order_count DESC;


-- -----------------------------------------------------------------------------
-- CROSS-CHECK: revenue consistency between fct_orders and dim_customers
-- Expected: total revenue from both sources must match
-- -----------------------------------------------------------------------------
SELECT
    ROUND(SUM(f.REVENUE), 2)                  AS revenue_from_fact,
    ROUND(SUM(c.CUSTOMER_LIFETIME_VALUE), 2)  AS revenue_from_dim,  -- must match
    ROUND(SUM(f.REVENUE) - SUM(c.CUSTOMER_LIFETIME_VALUE), 2) AS gap  -- must be 0
FROM {{ ref('fct_orders') }} f
CROSS JOIN (SELECT SUM(CUSTOMER_LIFETIME_VALUE) AS clv_total FROM {{ ref('dim_customers') }}) c;
