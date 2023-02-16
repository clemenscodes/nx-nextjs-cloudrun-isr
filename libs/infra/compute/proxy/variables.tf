variable "project_id" {
  description = "The id of the project in which the proxy will be created"
  type        = string
}

variable "proxy_name" {
  description = "The name of the proxy which will be created"
  type        = string
}

variable "certificate_id" {
  description = "The id of the certificate which will be used for the proxy"
  type        = string
}

variable "url_map" {
  description = "The URL map which will be used for the proxy"
  type        = string
}
