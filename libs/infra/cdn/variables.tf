variable "project_id" {
  description = "The id of the project in which the CDN will be created"
  type        = string
}

variable "bucket" {
  description = "the name of the bucket that will be used for the CDN"
  type        = string
}

variable "domain" {
  description = "The apex domain that will be used"
  type        = string
}

variable "certificate_name" {
  description = "The name of the certificate that will be created"
  type        = string
}

variable "subdomain" {
  description = "The subdomain that will be used"
  type        = string
}

variable "region" {
  description = "The region in which the CDN will be created"
  type        = string
}
