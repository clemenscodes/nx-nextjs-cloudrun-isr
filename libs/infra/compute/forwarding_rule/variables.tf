variable "project_id" {
  description = "The id of the project in which the forwarding rule will be created"
  type        = string
}

variable "ip_address" {
  description = "The IP to which should be forwarded"
  type        = string
}

variable "forwarding_rule" {
  description = "The name of the forwarding rule which will be created"
  type        = string
}

variable "target" {
  description = "The target proxy"
  type        = string
}
