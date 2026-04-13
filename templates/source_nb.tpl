{%- extends 'nbextensions.tpl' -%} 

{%- block header -%}
{{ super() }}

 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.css">

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>

<link rel="stylesheet" type="text/css" href="https://min.gitcdn.xyz/cdn/ipython-contrib/jupyter_contrib_nbextensions/master/src/jupyter_contrib_nbextensions/nbextensions/toc2/main.css">

<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<script src="https://min.gitcdn.xyz/cdn/ipython-contrib/jupyter_contrib_nbextensions/master/src/jupyter_contrib_nbextensions/nbextensions/toc2/toc2.js"></script>

<script>
$( document ).ready(function(){
            var cfg = {{ nb.get('metadata', {}).get('toc', {})|tojson|safe }};
            cfg.navigate_menu=false;
            // fire the main function with these parameters
            require(['nbextensions/toc2/toc2'], function (toc2) {
                toc2.table_of_contents(cfg);
            });
    });
</script>
{%- endblock header -%}

{% block input_group %}
    {%- if not(cell.metadata.get('hide_input', False)) -%}
        {{ super() }}
    {%- endif -%}
{% endblock input_group %}


{% block data_priority %}
    {# Check if the output is an attachment and if it actually exists #}
    {% if output.output_type == 'display_data' and 'filenames' in output.metadata %}
        {%- set filename = output.metadata.filenames.get('image/png') or output.metadata.filenames.get('image/jpeg') -%}
        {%- if filename and not path.exists(filename) -%}
            {# Do nothing, effectively skipping the missing file #}
        {%- else -%}
            {{ super() }}
        {%- endif -%}
    {% else %}
        {{ super() }}
    {% endif %}
{% endblock data_priority %}

{# Override the attachment filter specifically #}
{% macro get_attachment(res, filenames) %}
    {% set filename = filenames.get('image/png') or filenames.get('image/jpeg') %}
    {% if filename and path.exists(filename) %}
        {{ filename }}
    {% endif %}
{% endmacro %}
