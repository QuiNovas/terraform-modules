variable "description" {
  default = ""
  type    = "string"
}

variable "name" {
  type = "string"
}

variable "rotation_lambda_arn" {
  type = "string"
}

variable "rotation_days" {
  default = 30
  type    = "string"
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "value" {
  default = " "
  type    = "string"
}
