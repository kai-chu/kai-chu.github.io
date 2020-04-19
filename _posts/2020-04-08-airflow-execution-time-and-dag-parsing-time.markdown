---
layout: post
title:  "Understand airflow execution time and dag parsing time"
date:   2020-04-08 14:28:39 +0200
categories: airflow bigdata datalake scheduler
---

Airflow dags are written in python, there are actually two runtimes for the same codes. Firstly, airflow will parse the dags and create metadata in the database
And then when execution time is met, worker will run the python codes to do the actual schedule work.

Don't mix them when writting a airflow dag. I'll have a small example to tell the differences in between.

In this example, I want to demo how it is important for developers to keep that in mind.
Usually, when we create a dag, we need to give a paramerter so that we can reuse it in different environments without changing the code.
It is implemented by using variables. 
In the following case, I want to get the python pip version and show it when the dag is executed. 
I have printed in two places. One is the root level and the other one is in the python operator's callable function.

```
//demo-airflow-capability.py
import os
...
print(os.environ['PYTHON_PIP_VERSION'])

def print_env():
    print(os.environ['PYTHON_PIP_VERSION'])

with dag:
    os_operator = PythonOperator(task_id = "os_operator", python_callable=print_env)
...
```

As we know, we can use python demo-airflow-capability.py to validate the syntax, which is also how the parse does. 
The python version is printed pip version is shown once when parsed
```
$ python demo-airflow-capability.py
'20.0.2'
```

When we trigger the dag to be executed, you will find the python pip version `'20.0.2'` is printed once as well.
That is from the python operator. 
To test a dag execution, we can use the command from airflow cli
```
$ airflow test demo-airflow-capability os_operator -e 2020-04-08
```

Conclusion:
1. The same dag file will be parsed and executed in two different places with different logic routines.
2. Think dag file as a main entry of parser
3. Think root operator of the dependency tree as a main entry of executor
4. Keep time consuming operations out of dag parsing phase, such as fetching [variables](https://airflow.apache.org/docs/stable/best-practices.html#variables)

Appendix:

Dag file demo-airflow-capability.py
```
from airflow.utils.dates import days_ago
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
import os

args = {
    'owner': 'airflow',
    'start_date': days_ago(2),
}

dag = DAG(
    dag_id='demo-airflow-capability',
    default_args=args,
    schedule_interval="@once",
    tags=['example']
)


print(os.environ['PYTHON_PIP_VERSION'])

def print_env():
    print(os.environ['PYTHON_PIP_VERSION'])

with dag:
    os_operator = PythonOperator(task_id = "os_operator", python_callable=print_env)

os_operator
```
