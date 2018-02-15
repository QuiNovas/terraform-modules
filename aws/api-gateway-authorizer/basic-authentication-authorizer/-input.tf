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

variable "rest_api_id" {
  type = "string"
}

variable "write_capacity" {
  type = "string"
  default = "1"
}