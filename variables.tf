
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "entitlement_key" {
  type        = string
  description = "The entitlement key required to access Cloud Pak images"
  sensitive   = true
}

variable "license" {
  type        = string
  description = "License string for required MQ version"
  default     = "L-RJON-C7QG3S"
}

variable "license_use" {
  type        = string
  description = "Usage for Production or Non-Production"
  default     = "NonProduction"
}

variable "qmgr_name" {
  type        = string
  description = "Name of queue manager to be created"
  default     = "QM1"
}


variable "qmgr_instance_name" {
  type        = string
  description = "Name of MQ instance to be created"
  default     = "telco-cloud"
}

variable "cpulimits" {
  type        = string
  description = "CPU limits for the queue manager instance"
  default     = "500m"
}

variable "cpurequests" {
  type        = string
  description = "CPU requests for the queue manager instance"
  default     = "500m"
}

variable "storageclass" {
  type        = string
  description = "CPU requests for the queue manager instance"
  default     = "portworx-db2-rwo-sc"
}

variable "mq_version" {
type        = string
description = "Version of MQ to be installed"
default     = "9.2.4.0-r1"
}

variable "config_map" {
  type        = string
  description = "Name of config map to created"
}