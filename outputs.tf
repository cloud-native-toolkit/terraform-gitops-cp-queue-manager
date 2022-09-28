
output "instance_name" {
  description = "The name of the module"
  value       = local.instance_name
}

output "qmgr_instance_name" {
  description = "Name of queue manager created"
  value       = var.qmgr_instance_name
}

output "config_map" {
  value = var.config_map
}


output "name" {
  description = "The name of the module"
  value       = local.instance_name
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = var.namespace
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [resource.gitops_module.setup_gitops]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = local.type
  depends_on  = [resource.gitops_module.setup_gitops]
}
