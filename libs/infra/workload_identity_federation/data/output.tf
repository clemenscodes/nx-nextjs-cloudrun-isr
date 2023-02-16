output "wif_principal" {
  value = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/attribute.repository/${var.repo_owner}/${var.repo}"
}

output "provider" {
  value = "projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/providers/${var.workload_identity_provider_pool_id}"
}

output "service_account_email" {
  value = data.google_service_account.wif_sa.email
}

output "domain" {
  value = var.domain
}

output "org_id" {
  value = data.google_organization.org.org_id
}

output "bucket" {
  value = var.bucket
}

output "org_name" {
  value = data.google_organization.org.name
}

output "region" {
  value = var.default_region
}

output "project_id" {
  value = var.default_project_id
}

output "project_name" {
  value = var.default_project_name
}

output "folder_name" {
  value = var.default_folder_name
}

output "workload_identity_service_account_id" {
  value = var.workload_identity_service_account_id
}

output "workload_identity_pool_id" {
  value = var.workload_identity_pool_id
}

output "workload_identity_provider_pool_id" {
  value = var.workload_identity_provider_pool_id
}

output "repo" {
  value = var.repo
}

output "repo_owner" {
  value = var.repo_owner
}
