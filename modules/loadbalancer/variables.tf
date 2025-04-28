variable "name" {
  description = "Name of the load balancer."
  type        = string
}

variable "labels" {
  description = "User-defined labels for created resources."
  type        = map(any)
}

variable "load_balancer_type" {
  description = "Type of the load balancer."
  type        = string
}

variable "location" {
  description = "Load balancer location name or ID."
  type        = string
}

variable "algorithm" {
  description = "Load balancing algorithm."
  type        = string
  validation {
    condition     = contains(["round_robin", "least_connections"], var.algorithm)
    error_message = <<-EOF
    The `algorithm` property must be of "round_robin" or "least_connections" value.
    EOF
  }
}

variable "services" {
  description = "Map of services associated with the load balancer."
  type = map(object({
    protocol         = string
    listen_port      = optional(number)
    destination_port = optional(number)
    sticky_sessions  = bool
    certificates     = optional(list(number))
    health_check = object({
      protocol     = string
      port         = optional(number)
      interval     = number
      timeout      = number
      retries      = optional(number)
      domain       = optional(string)
      path         = optional(string)
      response     = optional(string)
      status_codes = optional(list(string))
      check_tls    = optional(bool)
    })
  }))
  validation {
    condition     = alltrue([for _, service in var.services : contains(["tcp", "http", "https"], service.protocol)])
    error_message = <<-EOF
    The `protocol` property must be of "tcp", "http" or "https" value.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : service.protocol == "tcp" ? service.listen_port != null : false])
    error_message = <<-EOF
    When `protocol` property is "tcp", the `listen_port` property must be set.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : service.listen_port > 1 && service.listen_port < 65535 if service.listen_port != null])
    error_message = <<-EOF
    The `listen_port` property value must be a number between 1 and 65535.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : service.protocol == "tcp" ? service.destination_port != null : false])
    error_message = <<-EOF
    When `protocol` property is "tcp", the `destination_port` property must be set.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : service.destination_port > 1 && service.destination_port < 65535 if service.destination_port != null])
    error_message = <<-EOF
    The `destination_port` property value must be a number between 1 and 65535.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : service.protocol == "https" ? service.certificates != null : false])
    error_message = <<-EOF
    When `protocol` property is "https", the `certificates` property must be set.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : contains(["tcp", "http"], service.health_check.protocol)])
    error_message = <<-EOF
    The `health_check.protocol` property must be of "tcp" or "http" value.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : service.health_check.protocol == "tcp" ? service.health_check.port != null : false])
    error_message = <<-EOF
    When `health_check.protocol` property is "tcp", the `health_check.port` property must be set.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : service.health_check.protocol == "http" ? service.health_check.domain != null : false])
    error_message = <<-EOF
    When `health_check.protocol` property is "http", the `health_check.domain` property must be set.
    EOF
  }
  validation {
    condition     = alltrue([for _, service in var.services : service.health_check.protocol == "http" ? service.health_check.path != null : false])
    error_message = <<-EOF
    When `health_check.protocol` property is "http", the `health_check.path` property must be set.
    EOF
  }
}
