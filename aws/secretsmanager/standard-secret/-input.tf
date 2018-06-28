variable "description" {
  default = ""
  type    = "string"
}

variable "name" {
  type = "string"
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "value" {
  type = "map"
}
