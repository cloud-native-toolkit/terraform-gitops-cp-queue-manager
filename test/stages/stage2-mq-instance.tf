module "mq_instance" {
  source = "./module"

  depends_on = [
    module.gitops-cp-mq
  ]

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  #namespace = module.gitops_namespace.name
  namespace = var.namespace
  kubeseal_cert = module.gitops.sealed_secrets_cert
  entitlement_key = module.cp_catalogs.entitlement_key
  license = module.cp4i-dependencies.mq.license
  qmgr_instance_name = var.qmgr_instance_name
  qmgr_name = var.qmgr_name
}
