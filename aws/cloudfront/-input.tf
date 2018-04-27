variable "acm_certificate_arn" {
  type = "string"
}

variable "aliases" {
  type = "list"
}

variable "comment" {
  type = "string"
}

variable "default_root_object" {
  default = "index.html"
  type    = "string"
}

variable "distribution_name" {
  type = "string"
}

variable "log_bucket" {
  type = "string"
}

variable "price_class" {
  default = "PriceClass_100"
  type    = "string"
}

variable "web_acl_id" {
  default = ""
  type    = "string"
}