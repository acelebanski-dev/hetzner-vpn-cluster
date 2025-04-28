output "server_id" {
  description = "The identifier of the created server."
  value       = hcloud_server.this.id
}

output "server_public_ipv4" {
  description = "The IPv4 of the created server."
  value       = hcloud_primary_ip.this[0].ip_address
}
