select
    order_id,
    try_to_number(order_item_id)          as order_item_id,
    product_id,
    seller_id,
    try_to_timestamp(shipping_limit_date) as shipping_limit_at,
    try_to_decimal(price, 10, 2)          as price,
    try_to_decimal(freight_value, 10, 2)  as freight_value
from {{ source('olist', 'order_items') }}