{% macro limit_in_dev(n=100) %}
    {% if target.name == 'dev' %}
        limit {{ n }}
    {% endif %}

{% endmacro %}