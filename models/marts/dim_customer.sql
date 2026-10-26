with snap as (
    select * from {{ ref('customers_snapshot') }}
)

select
    dbt_scd_id                as customer_sk,
    customer_unique_id,
    customer_city             as city,
    customer_state            as state,
    customer_zip_code_prefix  as zip_code_prefix,

    case
        when dbt_valid_from = min(dbt_valid_from) over (partition by customer_unique_id)
        then '1900-01-01'::timestamp_ntz
        else dbt_valid_from
    end                                                as valid_from,
    coalesce(dbt_valid_to, '9999-12-31'::timestamp_ntz) as valid_to,
    case
        when dbt_valid_to is null then 'Yes'   
        else 'No'                              
    end                               as is_current
from snap

union all

select '-1', '-1', 'Unknown', 'Unknown', 'Unknown',
       '1900-01-01'::timestamp_ntz, '9999-12-31'::timestamp_ntz, 'Yes'