output "loadbalancers_public_ipv4" {
  description = "The IPv4 of the created load balancers."
  value       = { for k, v in module.loadbalancer : k => v.loadbalancer_public_ipv4 }
}

output "servers_public_ipv4" {
  description = "The IPv4 of the created servers."
  value       = { for k, v in module.server : k => v.server_public_ipv4 }
}
