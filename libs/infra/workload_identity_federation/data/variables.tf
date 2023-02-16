variable "domain" {
  description = "The domain of the organization"
  type        = string
  #   default     = ""
}

variable "region" {
  description = "The region for the settings project"
  type        = string
  #   default     = ""
}

variable "project_id" {
  description = "The id of the settings project"
  type        = string
  #   default     = ""
}

variable "project_name" {
  description = "The name of the settings project"
  type        = string
  #   default     = ""
}

variable "billing_account" {
  description = "The billing account that should be enabled for the project"
  type        = string
  #   default     = ""
}

variable "folder_name" {
  description = "The name of folder in which the settings project will be created"
  type        = string
  #   default     = ""
}

variable "bucket" {
  description = "The name of the state bucket that will be created for the settings project"
  type        = string
  #   default     = ""
}

variable "workload_identity_service_account_id" {
  description = "The name of the service account that will be used for workload identity federation"
  type        = string
  #   default     = ""
}

variable "workload_identity_pool_id" {
  description = "The name of the pool that will be used for workload identity federation"
  type        = string
  #   default     = ""
}

variable "workload_identity_provider_pool_id" {
  description = "The name of the provider that will be used for the pool"
  type        = string
  #   default     = ""
}

variable "repo_owner" {
  description = "The GitHub username that owns the repository"
  type        = string
  #   default     = ""
}

variable "repo" {
  description = "The name of the repository"
  type        = string
  #   default     = ""
}
