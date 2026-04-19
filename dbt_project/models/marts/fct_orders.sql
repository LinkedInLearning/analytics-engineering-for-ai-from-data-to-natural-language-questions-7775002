with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

final as (
    select
        o.ORDER_ID,
        o.CUSTOMER_ID,
        o.PRODUCT_ID,
        o.ORDER_DATE,
        o.QUANTITY,
        o.UNIT_PRICE,
        round(o.QUANTITY * o.UNIT_PRICE, 2) as REVENUE,
        o.ORDER_STATUS,
        c.NAME as CUSTOMER_NAME,
        c.SEGMENT as CUSTOMER_SEGMENT,
        c.COUNTRY_CODE,
        p.PRODUCT_NAME,
        p.CATEGORY,
        p.BRAND_NAME
    from orders o
    left join customers c on o.CUSTOMER_ID = c.CUSTOMER_ID
    left join products p on o.PRODUCT_ID = p.PRODUCT_ID
)

select * from final
