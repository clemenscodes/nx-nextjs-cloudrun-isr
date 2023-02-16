resource "google_compute_target_https_proxy" "default" {
  name             = var.proxy_name
  project          = var.project_id
  url_map          = var.url_map
  ssl_certificates = [var.certificate_id]
}
