
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Elasticsearch Initializing Shards Failure on Kubernetes.
---

This incident type refers to an issue with initializing shards in Elasticsearch, which can cause problems with accessing and managing data in the system. When this incident occurs, it can impact the overall performance and availability of Elasticsearch, potentially causing downtime or data loss. Immediate action is needed to resolve the issue and prevent any further impact on the system.

### Parameters
```shell
export ELASTICSEARCH_POD_NAME="PLACEHOLDER"

export ELASTICSEARCH_SERVICE="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"

export MEMORY_THRESHOLD="PLACEHOLDER"

export NEW_REPLICA_COUNT="PLACEHOLDER"

export CPU_THRESHOLD="PLACEHOLDER"
```

## Debug

### List all Elasticsearch pods in the current namespace
```shell
kubectl get pods -l app=elasticsearch
```

### Check the logs of a specific Elasticsearch pod for any errors related to shards initialization
```shell
kubectl logs ${ELASTICSEARCH_POD_NAME} | grep "initialization failed"
```

### Check the status of Elasticsearch shards initialization using the Elasticsearch API
```shell
curl -sS ${ELASTICSEARCH_SERVICE}:9200/_cluster/health?pretty=true | grep "initializing_shards"
```

### Check the Elasticsearch cluster status to see if any nodes have been removed or are not responding
```shell
curl -sS ${ELASTICSEARCH_SERVICE}:9200/_cluster/health?pretty=true | grep "status"
```

### Check the Elasticsearch logs for any errors related to shards initialization or cluster status
```shell
kubectl logs ${ELASTICSEARCH_POD_NAME} | grep "shards" && kubectl logs ${ELASTICSEARCH_POD_NAME} | grep "cluster"
```

### Check the Kubernetes events related to Elasticsearch pods and services to see if any errors have been reported
```shell
kubectl get events --sort-by=.metadata.creationTimestamp | grep "Elasticsearch"
```

### Describe the Elasticsearch service to see if it's pointing to the correct pods and endpoints
```shell
kubectl describe svc ${ELASTICSEARCH_SERVICE}
```

### Check the Elasticsearch configuration to see if any changes have been made recently that could affect shards initialization
```shell
kubectl exec ${ELASTICSEARCH_POD_NAME} -- cat /usr/share/elasticsearch/config/elasticsearch.yml
```

## Repair

### Check system resources: Elasticsearch relies heavily on system resources such as memory and CPU. If the system is running low on resources, it can impact the initialization of shards. Check the system resource utilization and allocate additional resources as needed.
```shell


#!/bin/bash



# Set variables

NAMESPACE=${ELASTICSEARCH_NAMESPACE}

POD=${ELASTICSEARCH_POD_NAME}

CONTAINER=${CONTAINER_NAME}



# Check system resource utilization

MEMORY_THRESHOLD=${MEMORY_THRESHOLD}

CPU_THRESHOLD=${CPU_THRESHOLD}



MEMORY_USAGE=$(kubectl exec -n $NAMESPACE $POD -c $CONTAINER -- bash -c "free | awk '/Mem:/ {print $3/$2*100}'")

CPU_USAGE=$(kubectl exec -n $NAMESPACE $POD -c $CONTAINER -- top -bn1 | awk '/Cpu\(s\):/ {print $2}')



if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )) || (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then

    # Allocate additional resources

    kubectl scale deployment ${DEPLOYMENT_NAME} --replicas=${NEW_REPLICA_COUNT} -n ${NAMESPACE}

fi


```