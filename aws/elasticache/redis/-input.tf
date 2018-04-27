variable "name" {
  type = "string"
}

variable "replication_group_description" {
  type = "string"
}

variable "replication_group_id" {
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