resource "google_compute_managed_ssl_certificate" "default" {
  name    = var.certificate_name
  project = var.project_id
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
  managed {
    domains = [var.domain]
  }
}
