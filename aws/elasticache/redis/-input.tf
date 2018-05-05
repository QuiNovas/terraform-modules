variable "name" {
  type = "string"
}

variable "group_description" {
  type = "string"
}

variable "group_id" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "vpc_id" {
  type = "string"
}