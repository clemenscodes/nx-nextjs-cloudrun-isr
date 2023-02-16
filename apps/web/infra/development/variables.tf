variable "folder_name" {
  description = "The name of the folder in which the project for this application should be created"
  type        = string
  #   default     = ""
}

variable "project_id" {
  description = "The id of the project in which the buckets will be created"
  type        = string
  #   default     = ""
}

variable "project_name" {
  description = "The name of the project in which the buckets will be created"
  type        = string
  #   default     = ""
}

variable "billing_account" {
  description = "The billing account that should be enabled for the project"
  type        = string
  #   default     = ""
}

variable "state_bucket" {
  description = "The name of the state bucket that will be created"
  type        = string
  #   default     = ""
}

variable "isr_bucket" {
  description = "The name of the ISR bucket that will be created for the Cloud Run service"
  type        = string
  #   default     = ""
}

variable "cdn_bucket" {
  description = "The name of the cdn bucket that will be created"
  type        = string
  #   default     = ""
}

variable "cdn_subdomain" {
  description = "The subdomain that will be used for the CDN"
  type        = string
  #   default     = ""
}

variable "cdn_region" {
  description = "The region in which the CDN will be created"
  type        = string
  #   default     = ""
}

variable "repository_id" {
  description = "The name that should be used for the Artifact Repository in which the Docker images will be hosted"
  type        = string
  #   default     = ""
}

variable "artifact_region" {
  description = "The region of the Artifact Registry Repository"
  type        = string
  #   default     = ""
}

variable "image_name" {
  description = "The name that should be used for the Docker image of the Cloud Run service"
  type        = string
  #   default     = ""
}

variable "cloud_run_region" {
  description = "The region in which the Cloud Run service will be hosted"
  type        = string
  #   default     = ""
}

variable "cloud_run_service_name" {
  description = "The name for the Cloud Run service"
  type        = string
  #   default     = ""
}

variable "cloud_run_subdomain" {
  description = "The domain that will be used for the Cloud Run service"
  type        = string
  #   default     = ""
}

variable "git_commit_sha" {
  description = "The git commit which will be used as the tag for the image"
  type        = string
}
