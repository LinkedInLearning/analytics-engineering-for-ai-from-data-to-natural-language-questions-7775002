SELECT
    product_id AS PRODUCT_ID,
    name as PRODUCT_NAME,
    category as CATEGORY,
    brand as BRAND_NAME,
    base_price::numeric(10, 2) as BASE_PRICE
FROM {{ source('raw', 'products') }}