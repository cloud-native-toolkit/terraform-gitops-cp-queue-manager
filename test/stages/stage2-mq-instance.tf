module "mq_instance" {
  source = "./module"

  depends_on = [
    module.gitops-cp-mq
  ]

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name

  #kubeseal_cert = module.gitops.sealed_secrets_cert
  kubeseal_cert = module.cert.cert

  entitlement_key = module.cp_catalogs.entitlement_key
  qmgr_instance_name = var.qmgr_instance_name
  qmgr_name = var.qmgr_name
  config_map = var.config_map

  # Parameter specific to mq-instance
  storageClass = "ibmc-vpc-block-10iops-tier"

  # Pulling variables from CP4I dependency management
  mq_version  = module.cp4i-dependencies.mq.version
  license     = module.cp4i-dependencies.mq.license
  license_use = module.cp4i-dependencies.mq.license_use
}
