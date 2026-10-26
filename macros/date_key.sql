{% macro date_key(col) %}
    coalesce(to_number(to_char({{ col }}, 'YYYYMMDD')), 19000101)
{% endmacro %}