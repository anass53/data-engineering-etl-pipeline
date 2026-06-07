{% macro calculate_margin(profit_col, sales_col) %}
    CASE
        WHEN {{ sales_col }} = 0 THEN 0
        ELSE ROUND(({{ profit_col }}::numeric / {{ sales_col }}::numeric * 100), 2)
    END
{% endmacro %}