variable "project_id" {
  description = "The id of the project in which the URL map will be created"
  type        = string
}

variable "backend_id" {
  description = "The id of the backend that will be used"
  type        = string
}

variable "url_map" {
  description = "The name of the URL map that will be created"
  type        = string
}
