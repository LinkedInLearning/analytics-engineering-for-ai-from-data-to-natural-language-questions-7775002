with orders as (
    select * from {{ ref('stg_orders') }}
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
        p.CATEGORY,
        p.BRAND_NAME
    from orders o
    left join products p on o.PRODUCT_ID = p.PRODUCT_ID
)

select * from final