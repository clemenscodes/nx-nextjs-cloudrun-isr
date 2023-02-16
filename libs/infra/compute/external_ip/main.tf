resource "google_compute_global_address" "default" {
  name         = var.ip_name
  project      = var.project_id
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

