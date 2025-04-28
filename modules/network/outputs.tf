output "network_id" {
  description = "The identifier of the created network."
  value       = hcloud_network.this.id
}

output "subnet_ids" {
  description = "The identifiers of the created subnets."
  value       = { for k, v in hcloud_network_subnet.this : k => v.id }
}
