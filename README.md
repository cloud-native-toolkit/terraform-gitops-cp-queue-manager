# Starter kit for a Terraform GitOps module

This is a Starter kit to help with the creation of Terraform modules. The basic structure of a Terraform module is fairly
simple and consists of the following basic values:

- README.md - provides a description of the module
- main.tf - defines the logic for the module
- variables.tf (optional) - defines the input variables for the module
- outputs.tf (optional) - defines the values that are output from the module

Beyond those files, any other content can be added and organized however you see fit. For example, you can add a `scripts/` directory
that contains shell scripts executed by a `local-exec` `null_resource` in the terraform module. The contents will depend on what your
module does and how it does it.

## Instructions for creating a new module

1. Update the title and description in the README to match the module you are creating
2. Fill out the remaining sections in the README template as appropriate
3. Implement your logic in the in the main.tf, variables.tf, and outputs.tf
4. Use releases/tags to manage release versions of your module

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v12
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.5.3
- Helm provider >= 1.1.1 (provided by Terraform)

## Module dependencies

This module makes use of the output from other modules:

- GitOps - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Namespace - github.com/cloud-native-toolkit/terraform-gitops-namespace.git
- MQ Operator - github.com/cloud-native-toolkit/terraform-gitops-cp-mq.git

## Example usage

```hcl-terraform
module "mq_instance" {
   source = "github.com/cloud-native-toolkit/terraform-gitops-cp-queue-manager.git"

   depends_on = [
      module.gitops-cp-mq
   ]

   gitops_config = module.gitops.gitops_config
   git_credentials = module.gitops.git_credentials
   server_name = module.gitops.server_name
   namespace = module.gitops_namespace.name
   kubeseal_cert = module.gitops.sealed_secrets_cert
   entitlement_key = module.cp_catalogs.entitlement_key
   license = module.cp4i-dependencies.mq.license
   qmgr_instance_name = var.qmgr_instance_name
   qmgr_name = var.qmgr_name
   config_map = var.config_map
}

```
