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
