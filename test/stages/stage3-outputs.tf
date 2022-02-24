
resource null_resource write_outputs {
  provisioner "local-exec" {
    command = "echo \"$${OUTPUT}\" > gitops-output.json"

    environment = {
      OUTPUT = jsonencode({
        name        = module.mq_instance.instance_name
        queue_manager = module.mq_instance.qmgr_instance_name
      })
    }
  }
}
