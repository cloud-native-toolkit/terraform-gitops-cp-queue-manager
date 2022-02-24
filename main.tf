locals {
  base_name          = "ibm-mq"
  instance_name      = "${local.base_name}-instance"
  bin_dir            = module.setup_clis.bin_dir
  instance_chart_dir = "${path.module}/charts/ibm-mq-instance"
  instance_yaml_dir  = "${path.cwd}/.tmp/${local.instance_name}/chart/${local.instance_name}"
  layer              = "services"
  type               = "base"
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
          use     = var.use
        }
        queueManager = {
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
        version = var.mqversion
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
  module setup_clis {
    source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
  }


  module pull_secret {
    source = "github.com/cloud-native-toolkit/terraform-gitops-pull-secret"

    gitops_config   = var.gitops_config
    git_credentials = var.git_credentials
    server_name     = var.server_name
    kubeseal_cert   = var.kubeseal_cert
    namespace       = var.namespace
    docker_username = "cp"
    docker_password = var.entitlement_key
    docker_server   = "cp.icr.io"
    secret_name     = "ibm-entitlement-key"
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

  resource null_resource setup_instance_gitops {
    depends_on = [null_resource.create_instance_yaml]

    triggers = {
      bin_dir         = local.bin_dir
      name            = local.instance_name
      namespace       = var.namespace
      yaml_dir        = local.instance_yaml_dir
      server_name     = var.server_name
      layer           = local.layer
      type            = local.type
      git_credentials = yamlencode(var.git_credentials)
      gitops_config   = yamlencode(var.gitops_config)
    }

    provisioner "local-exec" {
      command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type=${self.triggers.type} --valueFiles='${local.values_file}'"

      environment = {
        GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
        GITOPS_CONFIG   = self.triggers.gitops_config
      }
    }

    provisioner "local-exec" {
      when    = destroy
      command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --delete --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

      environment = {
        GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
        GITOPS_CONFIG   = self.triggers.gitops_config
      }
    }
  }
