
output "instance_name" {
  description = "The name of the module"
  value       = local.instance_name
}

output "qmgr_instancename" {
  description = "Name of queue manager created"
  value       = var.instancename
}

output "bin_dir" {
  value = local.bin_dir
}
