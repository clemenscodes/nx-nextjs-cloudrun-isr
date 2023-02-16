output "ip" {
  value = module.external_ip.ip
}

output "subdomain" {
  value = var.subdomain
}

output "domain" {
  value = var.domain
}
