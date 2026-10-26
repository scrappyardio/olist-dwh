with orders as (
    select * from {{ ref('stg_orders') }}
),
customers as (
    select customer_id, customer_unique_id from {{ ref('stg_customers') }}
),
items as (
    select
        order_id,
        count(*)            as items_count,
        sum(price)          as items_value,
        sum(freight_value)  as freight_value
    from {{ ref('stg_order_items') }}
    group by order_id
),
payments as (
    select order_id, sum(payment_value) as payment_value
    from {{ ref('stg_payments') }}
    group by order_id
)

select
    o.order_id,
    o.order_status,
    coalesce(dc.customer_sk, '-1')               as customer_sk,
    {{ date_key('o.purchased_at') }}             as purchase_date_key,
    {{ date_key('o.approved_at') }}              as approved_date_key,
    {{ date_key('o.shipped_at') }}               as shipped_date_key,
    {{ date_key('o.delivered_at') }}             as delivered_date_key,
    {{ date_key('o.estimated_delivery_at') }}    as estimated_delivery_date_key,
    coalesce(i.items_count, 0)                   as items_count,
    coalesce(i.items_value, 0)                   as items_value,
    coalesce(i.freight_value, 0)                 as freight_value,
    coalesce(p.payment_value, 0)                 as payment_value,
    datediff('day', o.purchased_at, o.delivered_at) as days_to_deliver,
    case
        when o.delivered_at is null then null
        when o.delivered_at > o.estimated_delivery_at then 1
        else 0
    end                                          as is_late
from orders o
left join customers c
    on o.customer_id = c.customer_id
left join {{ ref('dim_customer') }} dc
    on  c.customer_unique_id = dc.customer_unique_id
    and o.purchased_at >= dc.valid_from
    and o.purchased_at <  dc.valid_to
left join items i
    on o.order_id = i.order_id
left join payments p
    on o.order_id = p.order_id