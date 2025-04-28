variable "name" {
  description = "Name of the network."
  type        = string
}

variable "labels" {
  description = "User-defined labels for created resources."
  type        = map(any)
}

variable "ip_range" {
  description = "IP range of the network in CIDR notation."
  type        = string
}

variable "subnets" {
  description = "Map of subnets within the network."
  type = map(object({
    type     = string
    zone     = string
    ip_range = string
  }))
  validation {
    condition     = alltrue([for _, subnet in var.subnets : contains(["cloud", "server", "vswitch"], subnet.type)])
    error_message = <<-EOF
    The `type` property must be of "cloud", "server" or "vswitch" value.
    EOF
  }
}

variable "routes" {
  description = "Map of routes within the network."
  type = map(object({
    destination = string
    gateway     = string
  }))
}
