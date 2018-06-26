variable "allow_self_invocation" {
  default = false
  type    = "string"
}

variable "dead_letter_arn" {
  type = "string"
}

variable "environment_variables" {
  default = {
    DEFAULT = "default"
  }
  type    = "map"
}

variable "handler" {
  type = "string"
}

variable "kms_key_arn" {
  type = "string"
}

variable "memory_size" {
  default = "128"
  type    = "string"
}

variable "name" {
  type = "string"
}

variable "policy_arns" {
  default = []
  type = "list"
}

variable "policy_arns_count" {
  default = 0
  type    = "string"
}

variable "runtime" {
  type = "string"
}

variable "s3_bucket" {
  type = "string"
}

variable "s3_object_key" {
  type = "string"
}

variable "timeout" {
  default = "3"
  type    = "string"
}
