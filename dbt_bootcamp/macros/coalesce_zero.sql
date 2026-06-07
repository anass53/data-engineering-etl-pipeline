{% macro coalesce_zero(col) %}
    COALESCE({{ col }}, 0)
{% endmacro %}


