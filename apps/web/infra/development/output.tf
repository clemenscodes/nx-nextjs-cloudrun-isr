output "url" {
  value = module.run.url
}

output "ip" {
  value = module.app.ip
}

output "subdomain" {
  value = module.app.subdomain
}

output "domain" {
  value = module.app.domain
}

output "cloud_run_subdomain" {
  value = module.run.cloud_run_subdomain
}
