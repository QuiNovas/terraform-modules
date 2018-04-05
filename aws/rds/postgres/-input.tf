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
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}

variable "tags" {
  type = "map"
}

variable "username" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}