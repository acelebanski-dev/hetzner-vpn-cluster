output "loadbalancer_id" {
  description = "The identifier of the created load balancer."
  value       = hcloud_load_balancer.this.id
}

output "loadbalancer_public_ipv4" {
  description = "The IPv4 of the created load balancer."
  value       = hcloud_load_balancer.this.ipv4
}
