variable "attributes" {
  type = "list"
}

variable "autoscaling_service_role_arn" {
  type = "string"
}

variable "global_secondary_indexes" {
  default = []
  type    = "list"
}

variable "global_secondary_indexes_count" {
  default = 0
  type    = "string"
}

variable "hash_key" {
  type = "string"
}

variable "local_secondary_indexes" {
  default = []
  type    = "list"
}

variable "name" {
  type = "string"
}

variable "read_capacity" {
  default = {
    max = 1
    min = 1
  }
  type    = "map"
}

variable "range_key" {
  default = ""
  type    = "string"
}

variable "stream_view_type" {
  default = ""
  type    = "string"
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "ttl_attribute_name" {
  default = ""
  type    = "string"
}

variable "write_capacity" {
  default = {
    max = 1
    min = 1
  }
  type    = "map"
}