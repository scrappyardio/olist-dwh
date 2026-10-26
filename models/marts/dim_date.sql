with spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2016-01-01' as date)",
        end_date="cast('2031-01-01' as date)"
    ) }}
)

select
    to_number(to_char(date_day, 'YYYYMMDD'))  as date_key,
    date_day::date                            as full_date,
    year(date_day)                            as year,
    quarter(date_day)                         as quarter,
    year(date_day) || '-Q' || quarter(date_day) as year_quarter,
    month(date_day)                           as month,
    monthname(date_day)                       as month_name,
    dayname(date_day)                         as weekday_name,
    dayofweekiso(date_day) in (6, 7)          as is_weekend
from spine

union all

select 19000101, '1900-01-01'::date, null, null, 'Unknown', null, null, null, null