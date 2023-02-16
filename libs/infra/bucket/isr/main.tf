resource "google_storage_bucket" "isr_bucket" {
  name                        = var.bucket
  location                    = "europe-west3"
  force_destroy               = false
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  project                     = var.project_id
  storage_class               = "STANDARD"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}
