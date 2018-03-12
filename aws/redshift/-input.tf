variable "availability_zones" {
  type = "list"
}

variable "cidr_block" {
  type = "string"
}

variable "log_bucket" {
  type = "string"
}

variable "master_password" {
  type = "string"
}

variable "master_username" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "node_type" {
  default = "dc2.large"
  type    = "string"
}

variable "number_of_nodes" {
  default = 1
  type    = "string"
}

variable "publicly_accessible" {
  default = true
  type    = "string"
}

variable "role_arns" {
  default = []
  type    = "list"
}

variable "statement_timeout" {
  default = 0
  type    = "string"
}

variable "use_fips_ssl" {
  default = false
  type    = "string"
}