variable "delegation_set_id" {
  type    = "string"
  default = ""
}

variable "name" {
  type = "string"
}

variable "record_set" {
  default = []
  type    = "list"
}

variable "record_set_count" {
  default = 0
  type    = "string"
}