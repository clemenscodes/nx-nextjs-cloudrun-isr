module "data" {
  source = "./data"
}

module "state_bucket" {
  source     = "../bucket/state"
  project_id = module.data.project_id
  bucket     = module.data.bucket
}

resource "google_folder" "default" {
  display_name = module.data.folder_name
  parent       = module.data.org_name
}

resource "google_project" "default" {
  name            = module.data.project_name
  project_id      = module.data.project_id
  billing_account = module.data.billing_account
  folder_id       = google_folder.default.name
}

resource "google_organization_iam_member" "organization_admin" {
  org_id = module.data.org_id
  role   = "roles/resourcemanager.organizationAdmin"
  member = "serviceAccount:${google_service_account.gh_actions.email}"
}

resource "google_organization_iam_member" "workload_identity_pool_admin" {
  org_id = module.data.org_id
  role   = "roles/iam.workloadIdentityPoolAdmin"
  member = "serviceAccount:${google_service_account.gh_actions.email}"
}

resource "google_organization_iam_member" "quota_admin" {
  org_id = module.data.org_id
  role   = "roles/servicemanagement.quotaAdmin"
  member = "serviceAccount:${google_service_account.gh_actions.email}"
}

resource "google_organization_iam_member" "storage_admin" {
  org_id = module.data.org_id
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.gh_actions.email}"
}

resource "google_organization_iam_member" "storage_object_admin" {
  org_id = module.data.org_id
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.gh_actions.email}"
}

resource "google_project_iam_member" "iam_service_account_user" {
  project = module.data.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.gh_actions.email}"
}

resource "google_project_iam_member" "iam_service_account_token_creator" {
  project = module.data.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.gh_actions.email}"
}

resource "google_project_service" "service_usage" {
  project = module.data.project_id
  service = "serviceusage.googleapis.com"
}

resource "google_project_service" "iam" {
  project = module.data.project_id
  service = "iam.googleapis.com"
}

resource "google_project_service" "iam_credentials" {
  project = module.data.project_id
  service = "iamcredentials.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager" {
  project = module.data.project_id
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_service_account" "gh_actions" {
  account_id = module.data.workload_identity_service_account_id
  project    = google_project.default.project_id
  depends_on = [google_project_service.iam_credentials]
}

resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = module.data.workload_identity_pool_id
  disabled                  = false
  project                   = google_project.default.number
  display_name              = "Workload Identity Pool"
  timeouts {}
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  disabled                           = false
  project                            = google_project.default.number
  workload_identity_pool_provider_id = module.data.workload_identity_provider_pool_id
  attribute_mapping = {
    "google.subject"             = "assertion.sub",
    "attribute.actor"            = "assertion.actor",
    "attribute.repository"       = "assertion.repository",
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  oidc {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
  timeouts {}
}

resource "google_project_iam_member" "wif" {
  project = module.data.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = module.data.wif_principal
}

resource "google_project_iam_member" "wif_service_account_token_creator" {
  project = module.data.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = module.data.wif_principal
}

resource "google_project_iam_member" "wif_service_account_user" {
  project = module.data.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = module.data.wif_principal
}
