
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
