output "url" {
  value = google_cloud_run_v2_service.default.uri
}

output "cloud_run_subdomain" {
  value = var.cloud_run_subdomain
}
