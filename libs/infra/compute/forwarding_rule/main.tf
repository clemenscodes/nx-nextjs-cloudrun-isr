resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.forwarding_rule
  project               = var.project_id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = var.target
  ip_address            = var.ip_address
}
