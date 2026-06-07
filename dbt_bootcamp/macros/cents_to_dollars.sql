{% macro cents_to_dollars(col) %}
    ROUND({{ col }}::numeric / 100, 2)
{% endmacro %}