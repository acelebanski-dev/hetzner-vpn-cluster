output "firewall_id" {
  description = "The identifier of the created firewall."
  value       = hcloud_firewall.this.id
}
