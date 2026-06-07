{%macro classify_performance(sales_col, low=100, high=500)%}
    CASE
        WHEN {{sales_col}} < {{low}} THEN 'low'
        WHEN {{sales_col}} <= {{high}} THEN 'medium'
        ELSE 'High'
    END
{% endmacro %}