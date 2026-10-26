select
    {{ dbt_utils.generate_surrogate_key(['p.product_id']) }} as product_sk,
    p.product_id,
    coalesce(t.category_name_en, p.category_name_pt, 'unknown') as category,
    p.photos_qty,
    p.weight_g
from {{ ref('stg_products') }} p
left join {{ ref('stg_category_translation') }} t
    on p.category_name_pt = t.category_name_pt

union all

select '-1', '-1', 'Unknown', null, null