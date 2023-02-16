locals {
  ip_name         = "${var.bucket}-ip"
  url_map         = "${var.bucket}-https-lb"
  proxy_name      = "${local.url_map}-proxy"
  forwarding_rule = "${local.url_map}-forwarding-rule"
  domain          = "${var.subdomain}.${var.domain}"
}

module "cdn_bucket" {
  source     = "../bucket/cdn"
  region     = var.region
  bucket     = var.bucket
  project_id = var.project_id
}

module "external_ip" {
  source     = "../compute/external_ip"
  ip_name    = local.ip_name
  project_id = var.project_id
}

module "backend_bucket" {
  source     = "../compute/backend_bucket"
  project_id = var.project_id
  bucket     = var.bucket
}

module "url_map" {
  source     = "../compute/url_map"
  url_map    = local.url_map
  project_id = var.project_id
  backend_id = module.backend_bucket.id
}

module "certificate" {
  source           = "../compute/certificate"
  certificate_name = var.certificate_name
  project_id       = var.project_id
  domain           = local.domain
}

module "proxy" {
  source         = "../compute/proxy"
  proxy_name     = local.proxy_name
  project_id     = var.project_id
  url_map        = module.url_map.id
  certificate_id = module.certificate.id
}

module "forwarding_rule" {
  source          = "../compute/forwarding_rule"
  forwarding_rule = local.forwarding_rule
  project_id      = var.project_id
  target          = module.proxy.id
  ip_address      = module.external_ip.ip
}
