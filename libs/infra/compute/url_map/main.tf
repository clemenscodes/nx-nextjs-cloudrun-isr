resource "google_compute_url_map" "default" {
  name            = var.url_map
  project         = var.project_id
  default_service = var.backend_id
}
