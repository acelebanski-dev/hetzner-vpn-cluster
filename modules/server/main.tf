resource "hcloud_primary_ip" "this" {
  count = var.create_public_ipv4 ? 1 : 0

  name          = "${var.name}-public-ip"
  labels        = var.labels
  datacenter    = var.datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

resource "hcloud_server" "this" {
  name        = var.name
  labels      = var.labels
  server_type = var.type
  image       = var.image
  datacenter  = var.datacenter

  ssh_keys     = var.ssh_keys
  user_data    = var.user_data
  firewall_ids = var.firewall_ids

  network {
    network_id = var.network_id
    ip         = var.private_ip
    alias_ips  = var.alias_ips
  }

  public_net {
    ipv4_enabled = var.create_public_ipv4
    ipv4         = hcloud_primary_ip.this[0].id
    ipv6_enabled = false
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "hcloud_load_balancer_target" "this" {
  count = var.loadbalancer_id != null ? 1 : 0

  type             = "server"
  load_balancer_id = var.loadbalancer_id
  server_id        = hcloud_server.this.id
  use_private_ip   = true
}
