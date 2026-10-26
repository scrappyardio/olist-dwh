with items as (
    select * from {{ ref('stg_order_items') }}
),
orders as (
    select * from {{ ref('stg_orders') }}
),
customers as (
    select customer_id, customer_unique_id from {{ ref('stg_customers') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['i.order_id', 'i.order_item_id']) }} as order_item_sk,
    i.order_id                          as order_id_dd,   
    i.order_item_id,
    {{ date_key('o.purchased_at') }}    as purchase_date_key,
    coalesce(dc.customer_sk, '-1')      as customer_sk,
    coalesce(dp.product_sk, '-1')       as product_sk,
    coalesce(ds.seller_sk, '-1')        as seller_sk,
    i.price,
    i.freight_value,
    i.price + i.freight_value           as total_value
from items i
join orders o
    on i.order_id = o.order_id
left join customers c
    on o.customer_id = c.customer_id

left join {{ ref('dim_customer') }} dc
    on  c.customer_unique_id = dc.customer_unique_id
    and o.purchased_at >= dc.valid_from
    and o.purchased_at <  dc.valid_to
left join {{ ref('dim_product') }} dp
    on i.product_id = dp.product_id
left join {{ ref('dim_seller') }} ds
    on i.seller_id = ds.seller_id