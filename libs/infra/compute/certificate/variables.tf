variable "project_id" {
  description = "The id of the project in which the certificate will be created"
  type        = string
}

variable "certificate_name" {
  description = "The name of the certificate will be created"
  type        = string
}

variable "domain" {
  description = "The domain for which the certificate will be created"
  type        = string
}
