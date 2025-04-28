module "network" {
  source = "../modules/network"

  for_each = var.networks

  name     = "${var.name_prefix}${each.value.name}"
  labels   = var.global_labels
  ip_range = each.value.ip_range
  subnets  = { for k, v in each.value.subnets : k => merge(v, { zone = var.zone }) }
  routes   = each.value.routes
}

module "firewall" {
  source = "../modules/firewall"

  for_each = var.firewalls

  name   = "${var.name_prefix}${each.value.name}"
  labels = var.global_labels
  rules  = each.value.rules
}

resource "hcloud_uploaded_certificate" "this" {
  for_each = var.certificates

  name        = "${var.name_prefix}${each.value.name}"
  labels      = var.global_labels
  private_key = file(each.value.private_key_path)
  certificate = file(each.value.certificate_path)
}

module "loadbalancer" {
  source = "../modules/loadbalancer"

  for_each = var.loadbalancers

  name               = "${var.name_prefix}${each.value.name}"
  labels             = var.global_labels
  load_balancer_type = each.value.load_balancer_type
  location           = var.location
  algorithm          = each.value.algorithm
  services           = { for k, v in each.value.services : k => merge(v, { certificates = [for _, v in hcloud_uploaded_certificate.this : v.id] }) }
}

resource "hcloud_ssh_key" "this" {
  for_each = var.ssh_keys

  name       = "${var.name_prefix}${each.value.name}"
  labels     = var.global_labels
  public_key = file(each.value.path)
}

module "server" {
  source = "../modules/server"

  for_each = var.servers

  name       = "${var.name_prefix}${each.value.name}"
  labels     = var.global_labels
  location   = var.location
  datacenter = var.datacenter
  type       = each.value.type
  image      = each.value.image

  network_id         = module.network[each.value.network_key].network_id
  private_ip         = each.value.private_ip
  alias_ips          = each.value.alias_ips
  create_public_ipv4 = each.value.create_public_ipv4

  ssh_keys  = [for _, v in hcloud_ssh_key.this : v.id]
  user_data = file(each.value.user_data_path)

  firewall_ids    = try(module.firewall[each.value.firewall_key].firewall_id, null)
  loadbalancer_id = try(module.loadbalancer[each.value.loadbalancer_key].loadbalancer_id, null)
}
