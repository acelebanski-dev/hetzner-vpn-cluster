variable "hcloud_token" {
  sensitive = true
}

variable "name_prefix" {
  description = "Name prefix that will be added to all created resources."
  default     = ""
  type        = string
}

variable "global_labels" {
  description = "User-defined labels for created resources."
  default     = {}
  type        = map(any)
}

variable "zone" {
  description = "Network zone name."
  type        = string
}

variable "location" {
  description = "Server location name or ID."
  type        = string
}

variable "datacenter" {
  description = "Server data center name or ID."
  type        = string
}

variable "networks" {
  description = "Map of networks."
  default     = {}
  type = map(object({
    name     = string
    ip_range = string
    subnets = map(object({
      type     = optional(string, "cloud")
      ip_range = string
    }))
    routes = optional(map(object({
      destination = string
      gateway     = string
    })), {})
  }))
}

variable "firewalls" {
  description = "Map of firewalls."
  default     = {}
  type = map(object({
    name = string
    rules = map(object({
      description     = optional(string)
      direction       = string
      protocol        = string
      port            = optional(string)
      source_ips      = optional(list(string))
      destination_ips = optional(list(string))
    }))
  }))
}

variable "certificates" {
  description = "Map of certificates to be used with load balancers."
  default     = {}
  type = map(object({
    name             = string
    private_key_path = string
    certificate_path = string
  }))
}

variable "loadbalancers" {
  description = "Map of load balancers."
  default     = {}
  type = map(object({
    name               = string
    load_balancer_type = optional(string, "lb11")
    algorithm          = optional(string, "round_robin")
    services = map(object({
      protocol         = string
      listen_port      = optional(number)
      destination_port = optional(number)
      sticky_sessions  = optional(bool, true)
      health_check = object({
        protocol     = string
        port         = optional(number)
        interval     = optional(number, 5)
        timeout      = optional(number, 5)
        retries      = optional(number, 3)
        domain       = optional(string)
        path         = optional(string, "/")
        response     = optional(string)
        status_codes = optional(list(string))
        check_tls    = optional(bool, false)
      })
    }))
  }))
}

variable "ssh_keys" {
  description = "Map of SSH keys which can be used to access created servers."
  default     = {}
  type = map(object({
    name = string
    path = string
  }))
}

variable "servers" {
  description = "Map of servers."
  default     = {}
  type = map(object({
    name               = string
    type               = optional(string, "cx22")
    image              = optional(string, "ubuntu-24.04")
    network_key        = string
    firewall_key       = optional(string)
    loadbalancer_key   = optional(string)
    private_ip         = string
    alias_ips          = optional(list(string), [])
    create_public_ipv4 = optional(bool, true)
    user_data_path     = optional(string)
  }))
}
