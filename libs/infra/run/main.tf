resource "google_service_account" "cloud_run_service_account" {
  account_id  = var.project_name
  project     = var.project_id
  description = "The service account that will be used by the Cloud Run instance. Needs access to Cloud Storage"
}

resource "google_project_iam_member" "storage_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloud_run_service_account.email}"
}

resource "google_cloud_run_v2_service" "default" {
  name     = var.cloud_run_service_name
  location = var.cloud_run_region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  template {
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    max_instance_request_concurrency = 80
    timeout                          = "300s"
    service_account                  = google_service_account.cloud_run_service_account.email
    scaling {
      min_instance_count = 0
      max_instance_count = 1000
    }
    containers {
      image = "${var.artifact_region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.image_name}:${var.git_commit_sha}"
      ports {
        container_port = 3000
      }
    }
  }
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
  lifecycle {
    prevent_destroy = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "noauth" {
  location    = google_cloud_run_v2_service.default.location
  project     = google_cloud_run_v2_service.default.project
  name        = google_cloud_run_v2_service.default.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

resource "google_cloud_run_domain_mapping" "default" {
  location = google_cloud_run_v2_service.default.location
  project  = google_cloud_run_v2_service.default.project
  name     = "${var.cloud_run_subdomain}.${var.domain}"
  metadata {
    namespace = var.project_id
  }
  spec {
    route_name = google_cloud_run_v2_service.default.name
  }
}
