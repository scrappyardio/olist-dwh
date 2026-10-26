select
    {{ dbt_utils.generate_surrogate_key(['seller_id']) }} as seller_sk,
    seller_id,
    city,
    state,
    zip_code_prefix
from {{ ref('stg_sellers') }}

union all

select '-1', '-1', 'Unknown', 'Unknown', 'Unknown'