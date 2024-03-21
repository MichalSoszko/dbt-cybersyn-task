{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if target.name == 'local' or target.name == 'local_staging' or target.name == 'local_inc' or target.name == 'merge-request' -%}
        {{ default_schema }}
    {%- else -%}
        {%- if custom_schema_name is not none -%}
            {{ custom_schema_name | trim }}
        {%- else -%}
            {{ default_schema }}
        {%- endif -%}
    {%- endif -%}
{%- endmacro %}
