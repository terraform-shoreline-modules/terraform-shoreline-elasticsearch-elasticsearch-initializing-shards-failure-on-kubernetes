resource "shoreline_notebook" "elasticsearch_initializing_shards_failure_on_kubernetes" {
  name       = "elasticsearch_initializing_shards_failure_on_kubernetes"
  data       = file("${path.module}/data/elasticsearch_initializing_shards_failure_on_kubernetes.json")
  depends_on = [shoreline_action.invoke_system_resource_utilization]
}

resource "shoreline_file" "system_resource_utilization" {
  name             = "system_resource_utilization"
  input_file       = "${path.module}/data/system_resource_utilization.sh"
  md5              = filemd5("${path.module}/data/system_resource_utilization.sh")
  description      = "Check system resources: Elasticsearch relies heavily on system resources such as memory and CPU. If the system is running low on resources, it can impact the initialization of shards. Check the system resource utilization and allocate additional resources as needed."
  destination_path = "/agent/scripts/system_resource_utilization.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_system_resource_utilization" {
  name        = "invoke_system_resource_utilization"
  description = "Check system resources: Elasticsearch relies heavily on system resources such as memory and CPU. If the system is running low on resources, it can impact the initialization of shards. Check the system resource utilization and allocate additional resources as needed."
  command     = "`chmod +x /agent/scripts/system_resource_utilization.sh && /agent/scripts/system_resource_utilization.sh`"
  params      = ["MEMORY_THRESHOLD","ELASTICSEARCH_POD_NAME","NEW_REPLICA_COUNT","DEPLOYMENT_NAME","CPU_THRESHOLD","NAMESPACE"]
  file_deps   = ["system_resource_utilization"]
  enabled     = true
  depends_on  = [shoreline_file.system_resource_utilization]
}

