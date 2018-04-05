variable "database_name" {
  type = "string"
}

variable "instance_class" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "parameters" {
  default = []
  type    = "list"
}

variable "subnet_ids" {
  type = "list"
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "username" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}