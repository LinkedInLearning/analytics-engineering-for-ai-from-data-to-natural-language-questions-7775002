with source as (
    SELECT
        order_id AS ORDER_ID,
        customer_id AS CUSTOMER_ID,
        product_id AS PRODUCT_ID,
        order_date AS ORDER_DATE,
        try_cast(quantity AS INTEGER) AS QUANTITY,
        try_cast(unit_price AS NUMERIC(10,2)) AS UNIT_PRICE,
        status as ORDER_STATUS
    FROM {{ source('raw', 'orders') }}
),

-- Fix 1: Standardize mixed date formats (MM/DD/YYYY and YYYY-MM-DD)
-- cast ORDER_DATE to date
date_fixed as (
    select
        ORDER_ID,
        CUSTOMER_ID,
        PRODUCT_ID,
        case
            when ORDER_DATE like '__/__/____'
                then strptime(ORDER_DATE, '%m/%d/%Y')::date
            else cast(ORDER_DATE as date)
        end as ORDER_DATE,
        QUANTITY,
        UNIT_PRICE,
        ORDER_STATUS
    from source
),

-- Fix 2: Remove rows with NULL customer_id
no_nulls as (
    SELECT
        *
    FROM date_fixed
    WHERE CUSTOMER_ID IS NOT NULL
),

-- Fix 3: Deduplicate rows based on order_id

deduplicated as (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY ORDER_DATE DESC) AS rn
    FROM no_nulls
),

cleaned_data as(
    SELECT
        ORDER_ID,
        CUSTOMER_ID,
        PRODUCT_ID,
        ORDER_DATE,
        QUANTITY,
        UNIT_PRICE,
        ORDER_STATUS
    FROM deduplicated
    WHERE rn = 1
    AND quantity > 0
)

SELECT * FROM cleaned_data
