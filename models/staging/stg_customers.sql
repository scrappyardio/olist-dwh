SELECT customer_id,
       customer_unique_id,
       customer_zip_code_prefix,
       initcap(trim(customer_city)) AS customer_city,
       upper(trim(customer_state)) AS customer_state
FROM {{ source('olist', 'customers') }}