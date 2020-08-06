---
layout: post
title:  "What is apache airflow"
date:   2020-08-07 00:06:06 +0200
categories: airflow bigdata datalake
---
## What is airflow

Airflow is an clustered platform to schedule, run-through and monitor a series of tasks in a directed acyclic graph (DAGs).
It gives better management capabilities to create, log and link jobs what would be done by cron jobs.

## Architecture

Airflow cluster setup will have webserver, scheduler, message broker and worker components as following. 
![Airflow arc](/assets/airflow/airflow_arc.jpg)
Webserver serves UI and scheduler will parse tasks defintion, the DAGs from Airflow Home folder, usually airflow maintainer 
will deploy their DAGs definition there and scheduler will parse them and add meta data in to the meta DB.
Each DAG will be given a trigger time, which is similar as cron, then it's met, scheduler will put the task into broker and one of the workers 
will pick up that task and run it. Workers will work on tasks while following the dependencies defined in the DAG. 

## Concepts to understand before start

### DAG
Directed Acyclic Graph – is a workflow of all the tasks you want to run, organized in a way that reflects their relationships and dependencies In general, each one should correspond to a single logical workflow

### DAG definition
Airflow use python file to declare dag objects, a DAG function is provided to accept configurations. e.g. dag=DAG('dag_name', default_args=default_args)

- Dag arguments
The arguments provided for the dag object when the dag is run
- Dag default arguments
The default dag argument, which is provided when defining the dag in dag definition python file
- Context manager
airflow will find a dag definition in a python and assign that dat to operators defined in that definition file
- Dag objects build
Airflow will find and run dag definition python files to create dags
- Task relationship
Tasks a a dag can has dependencies by using task_1 >> task_2, the same as task_1.set_downstream(task_2)
- Bitshift Composition
A convinient way to define relationships between tasks. >>
- Upstream
if we have a taskA, then the task running before it is the upstream of taskA, task A need to wait until upstream has completed successfully.
- Downsteam
if we have a taskA, then the task after it is the downstream of taskA

### Dagbag
A folder where airflow is searching DAG definition python files, execute and build DAG objects into airflow system. 
When searching for DAGs, Airflow only considers python files that contain the strings “airflow” and “DAG” by default. 
To consider all python files instead, disable the DAG_DISCOVERY_SAFE_MODE configuration flag.

### Task
A work unit in a DAG, it is an implementation of an Operator. for example a PythonOperator to execute some Python code, or a BashOperator to run a Bash command

### Task instance
A runtime exection of a task, It should be a combination of a DAG, a task, and a point in time (execution_date)

### Task lifecycle
A task goes through various stages from start to completion
![Airflow lifecycle](https://airflow.apache.org/docs/stable/_images/task_lifecycle_diagram.png)

### Operators
Operators is specific implementations of tasks. It defines what the task does and are only loaded by Airflow if they are assigned to a DAG.
e.g.
BashOperator - executes a bash command
PythonOperator - calls an arbitrary Python function
EmailOperator - sends an email
SimpleHttpOperator - sends an HTTP request

### Pool
A named of list of workers which can be refered by a task to manually balance airflow workload.

### Queue
Queue for a executor to cache tasks

### Worker
Processes to get tasks out from queue and run it, workers can listen to one or multiple queues of tasks. 