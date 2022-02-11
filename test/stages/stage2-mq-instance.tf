module "mq_instance" {
  source = "./module"

  depends_on = [
    module.gitops-cp-mq
  ]

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  #catalog = module.cp_catalogs.catalog_ibmoperators

  entitlement_key = module.cp_catalogs.entitlement_key
  license = module.cp4i-dependencies.mq.license
  #instance_version=module.cp4i-dependencies.mq.version
  #channel = module.cp4i-dependencies.mq.channel
}
