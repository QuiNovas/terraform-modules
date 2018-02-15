variable "groups_table_arn" {
  type = "string"
}

variable "groups_table_name" {
  type    = "string"
}

variable "name_prefix" {
  type = "string"
}

variable "read_capacity" {
  type = "string"
  default = "1"
}

variable "write_capacity" {
  type = "string"
  default = "1"
}