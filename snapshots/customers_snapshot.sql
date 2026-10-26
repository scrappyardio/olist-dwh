{% snapshot customers_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_unique_id',
        strategy='check',
        check_cols=['customer_city', 'customer_state', 'customer_zip_code_prefix']
    )
}}

select
    customer_unique_id,
    customer_zip_code_prefix,
    initcap(trim(customer_city))  as customer_city,
    upper(trim(customer_state))   as customer_state
from {{ source('olist', 'customers') }}

qualify row_number() over (partition by customer_unique_id order by customer_id) = 1

{% endsnapshot %}