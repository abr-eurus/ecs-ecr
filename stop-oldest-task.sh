#!/bin/bash

CLUSTER_NAME="abr-github"
SERVICE_NAME="abr"
tasks=$(aws ecs list-tasks --cluster $CLUSTER_NAME --service-name $SERVICE_NAME --query 'taskArns' --output text)

# Describe tasks to get launch times
oldest_task=""
oldest_time=""

for task in $tasks; do
    task_info=$(aws ecs describe-tasks --cluster $CLUSTER_NAME --tasks $task --query 'tasks[0].[taskArn, startedAt]' --output text)
    task_arn=$(echo $task_info | cut -d' ' -f1)
    started_at=$(echo $task_info | cut -d' ' -f2)
    
    if [ -z "$oldest_time" ] || [ "$started_at" \< "$oldest_time" ]; then
        oldest_time=$started_at
        oldest_task=$task_arn
    fi
done

echo $oldest_task