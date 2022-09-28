locals {
  base_name          = "ibm-mq"
  instance_name      = "${local.base_name}-instance"
  instance_chart_dir = "${path.module}/charts/ibm-mq-instance"
  instance_yaml_dir  = "${path.cwd}/.tmp/${local.instance_name}/chart/${local.instance_name}"
  layer              = "services"
  type               = "instances"
  application_branch = "main"
  layer_config       = var.gitops_config[local.layer]
  #values_file = "values-${var.server_name}.yaml"
  values_file        = "values.yaml"

  instance_values_content = {
    mqinstance = {
      name      = var.qmgr_instance_name
      namespace = var.namespace
      spec      = {
        license = {
          accept  = true
          license = var.license
          use     = var.license_use
        }
        template = {
          pod = {
            containers = [
              {
                name = "qmgr"
                env = [
                  {
                    name  = "MQSNOAUT"
                    value = "yes"
                  }
                ]
              }
            ]
          }
        }

        queueManager = {
          storage = {
            queueManager = {
              type = "persistent-claim"
            }
            defaultClass = var.storageClass
          }

          name = var.qmgr_name
          mqsc = [
            {
              configMap= {
                name= var.config_map,
                items= [
                  "config.mqsc"
                ]
              }
            }
          ]
        }
        version = var.mq_version
        web     = {
            enabled = true
          }

      }
    }
    configMap = {
      name = var.config_map
    }
  }
}

resource gitops_pull_secret cp_icr_io {
  name = "ibm-entitlement-key"
  namespace = var.namespace
  server_name = var.server_name
  branch = local.application_branch
  layer = local.layer
  credentials = yamlencode(var.git_credentials)
  config = yamlencode(var.gitops_config)
  kubeseal_cert = var.kubeseal_cert


  secret_name     = "ibm-entitlement-key"
  registry_server = "cp.icr.io"
  registry_username = "cp"
  registry_password = var.entitlement_key
}

resource null_resource create_instance_yaml {
  #depends_on = [null_resource.setup_subscription_gitops]
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.instance_name}' '${local.instance_chart_dir}' '${local.instance_yaml_dir}' '${local.values_file}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.instance_values_content)
    }
  }
}


resource gitops_module setup_gitops {
  depends_on = [null_resource.create_instance_yaml]


  name = local.instance_name
  namespace = var.namespace
  content_dir = local.instance_yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}

