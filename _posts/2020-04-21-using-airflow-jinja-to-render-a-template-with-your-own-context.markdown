---
layout: post
title:  "Using airflow jinja to render a template with your own context"
date:   2020-04-21 19:02:32 +0200
categories: airflow jinja python
---
Jinja is well explained when using with operators which has support for a template field. It could be a bash_command parameters in a BashOperator as following

```
templated_command = """
{% for i in range(5) %}
    echo "{{ ds }}"
    echo "{{ macros.ds_add(ds, 7)}}"
    echo "{{ params.my_param }}"
{% endfor %}
"""

t3 = BashOperator(
    task_id='templated',
    depends_on_past=False,
    bash_command=templated_command,
    params={'my_param': 'Parameter I passed in'},
    dag=dag,
)
```

Using jinja template in a op_args or op_kwargs in a python operator 
def my_sleeping_function(**context):
    # here context.random_base will be the actual execution_date, e.g. 2020-02-20
```
task = PythonOperator(
    task_id='sleep'
    python_callable=my_sleeping_function,
    op_kwargs={'random_base': '{{ds}}'},
    dag=dag,
)
```

however, if you have a python code where you want to render your own variables, you can using following method from helpers module.
There is an helper method which is built on top of jinja in airflow, you can import it in your dag file
```
from airflow.utils.helpers import parse_template_string
```

Suppose you have a template string in your dag definition, however, you only know the context when the dag task is running.
For example, the execution_date which is provided in context.ds
Then you can use parse_template_string method to get a template and use the render with context to get your filename as following

```
filename_template='abc-{{ds}}.csv'

def my_sleeping_function(**context):
  filename_template, filename_jinja_template = parse_template_string(filename_template)
  filename = filename_jinja_template.render(**context)

task = PythonOperator(
    task_id='sleep'
    python_callable=my_sleeping_function,
    op_kwargs={'random_base': '{{ds}}'},
    dag=dag,
)
```