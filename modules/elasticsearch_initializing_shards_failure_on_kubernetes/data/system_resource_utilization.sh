

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