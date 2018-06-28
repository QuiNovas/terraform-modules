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

variable "initial_value" {
  default = {
    SomeKey = "SomeValue"
  }
  type = "map"
}
