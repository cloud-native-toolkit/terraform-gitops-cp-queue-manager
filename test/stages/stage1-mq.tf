module gitops-cp-mq {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-mq.git"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  #kubeseal_cert = module.gitops.sealed_secrets_cert
  catalog = module.cp_catalogs.catalog_ibmoperators
  #platform_navigator_name = module.cp_platform_navigator.name

  # not sure if the remaining at needed.
  #license = module.cp4i-dependencies.mq.license
  #entitlement_key = module.cp_catalogs.entitlement_key
  channel = module.cp4i-dependencies.mq.channel
  namespace = module.gitops_namespace.name
}
