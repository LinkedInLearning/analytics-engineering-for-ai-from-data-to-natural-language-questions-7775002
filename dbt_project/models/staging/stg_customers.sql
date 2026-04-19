SELECT
    customer_id AS CUSTOMER_ID,
    name AS NAME,
    email AS EMAIL,
    country as COUNTRY_CODE,
    segment as SEGMENT,
    created_at::date AS CREATED_AT
FROM  {{ source('raw', 'customers') }}