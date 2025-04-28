variable "name" {
  description = "Name of the server."
  type        = string
}

variable "labels" {
  description = "User-defined labels for created resources."
  type        = map(any)
}

variable "location" {
  description = "Server location name or ID."
  type        = string
}

variable "datacenter" {
  description = "Server data center name or ID."
  type        = string
}

variable "type" {
  description = "Server type name or ID."
  type        = string
}

variable "image" {
  description = "Server image name or ID."
  type        = string
}

variable "network_id" {
  description = "Server network ID."
  type        = number
}

variable "private_ip" {
  description = "Server private IP address within the specified network."
  type        = string
}

variable "alias_ips" {
  description = "Server alias IP addresses within the specified network."
  type        = list(string)
}

variable "create_public_ipv4" {
  description = "Switch controlling the creation of public IPv4 address for the server."
  type        = bool
}

variable "ssh_keys" {
  description = "SSH Key names or IDs which should be injected into the server at creation time."
  type        = list(string)
}

variable "user_data" {
  description = "Cloud-Init user data to use during server creation."
  type        = string
}

variable "firewall_ids" {
  description = "Firewall IDs the server should be attached to on creation."
  type        = list(number)
}

variable "loadbalancer_id" {
  description = "Load balancer ID the server should be attached to on creation."
  type        = number
}
