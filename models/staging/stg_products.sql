select
    product_id,
    product_category_name              as category_name_pt,
    try_to_number(product_photos_qty)  as photos_qty,
    try_to_number(product_weight_g)    as weight_g
from {{ source('olist', 'products') }}