variable "name" {
  description = "Name of the firewall."
  type        = string
}

variable "labels" {
  description = "User-defined labels for created resources."
  type        = map(any)
}

variable "rules" {
  description = "Map of firewall rules."
  type = map(object({
    description     = optional(string)
    direction       = string
    protocol        = string
    port            = optional(string)
    source_ips      = optional(list(string))
    destination_ips = optional(list(string))
  }))
  validation {
    condition     = alltrue([for _, rule in var.rules : contains(["in", "out"], rule.direction)])
    error_message = <<-EOF
    The `direction` property must be of "in" or "out" value.
    EOF
  }
  validation {
    condition     = alltrue([for _, rule in var.rules : contains(["tcp", "udp", "icmp", "gre", "esp"], rule.protocol)])
    error_message = <<-EOF
    The `protocol` property must be of "tcp", "udp", "icmp", "gre" or "esp" value.
    EOF
  }
  validation {
    condition     = alltrue([for _, rule in var.rules : rule.direction == "in" ? length(rule.source_ips) > 0 : true])
    error_message = <<-EOF
    When `direction` property is "in", the `source_ips` property must be set.
    EOF
  }
  validation {
    condition     = alltrue([for _, rule in var.rules : rule.direction == "out" ? length(rule.destination_ips) > 0 : true])
    error_message = <<-EOF
    When `direction` property is "out", the `destination_ips` property must be set.
    EOF
  }
  validation {
    condition     = alltrue([for _, rule in var.rules : rule.protocol == "tcp" || rule.protocol == "udp" ? rule.port != null : true])
    error_message = <<-EOF
    When `protocol` property is "tcp" or "udp", the `port` property must be set.
    EOF
  }
}
