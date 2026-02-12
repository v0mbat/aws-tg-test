variable "name"        { 
    type = string 
}

variable "description" { 
    type = string 
}

variable "vpc_id"      { 
    type = string 
}
variable "tags"        { 
    type = map(string) 
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules with cidr_blocks"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
    description = optional(string)
  }))
  default = []
}

variable "ingress_with_self" {
  description = "List of ingress rules self target"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = optional(bool, true)
    description = optional(string)
  }))
  default = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules with cidr_blocks"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
    description = optional(string)
  }))
  default = []
}

variable "egress_with_self" {
  description = "List of egress rules self target"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = optional(bool, true)
    description = optional(string)
  }))
  default = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules with source_security_group_id"
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
    description              = optional(string)
  }))
  default = []
}

variable "egress_with_source_security_group_id" {
  description = "List of egress rules with source_security_group_id"
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
    description              = optional(string)
  }))
  default = []
}

variable "computed_ingress_rules" {
  description = "List of computed ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "computed_egress_rules" {
  description = "List of computed egress rules to create by name"
  type        = list(string)
  default     = []
}
