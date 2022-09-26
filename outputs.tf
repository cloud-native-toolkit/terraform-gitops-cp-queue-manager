
output "instance_name" {
  description = "The name of the module"
  value       = local.instance_name
}

output "qmgr_instance_name" {
  description = "Name of queue manager created"
  value       = var.qmgr_instance_name
}

output "bin_dir" {
  value = local.bin_dir
}

output "config_map" {
  value = var.config_map
}


output "name" {
  description = "The name of the module"
  value       = local.instance_name
  depends_on  = [gitops_module.module]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [gitops_module.module]
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = var.namespace
  depends_on  = [gitops_module.module]
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [gitops_module.module]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [gitops_module.module]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = local.type
  depends_on  = [gitops_module.module]
}
