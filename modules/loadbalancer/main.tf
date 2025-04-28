resource "hcloud_load_balancer" "this" {
  name               = var.name
  labels             = var.labels
  load_balancer_type = var.load_balancer_type
  location           = var.location

  algorithm {
    type = var.algorithm
  }
}

resource "hcloud_load_balancer_service" "this" {
  for_each = var.services

  load_balancer_id = hcloud_load_balancer.this.id
  protocol         = each.value.protocol
  listen_port      = each.value.listen_port
  destination_port = each.value.destination_port

  http {
    sticky_sessions = each.value.sticky_sessions
    certificates    = each.value.certificates
  }

  health_check {
    protocol = each.value.health_check.protocol
    port     = each.value.health_check.port
    interval = each.value.health_check.interval
    timeout  = each.value.health_check.timeout
    retries  = each.value.health_check.retries

    http {
      domain       = each.value.health_check.domain
      path         = each.value.health_check.path
      response     = each.value.health_check.response
      status_codes = each.value.health_check.status_codes
      tls          = each.value.health_check.check_tls
    }
  }
}
