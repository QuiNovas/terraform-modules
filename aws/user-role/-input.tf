variable "allowed_user_arns" {
  type = "list"
}

variable "allowed_user_names" {
  type = "list"
}

variable "name" {
  type = "string"
}

variable "policy_arns" {
  default = []
  type    = "list"
}

variable "policy_arn_count" {
  default = 0
  type    = "string"
}