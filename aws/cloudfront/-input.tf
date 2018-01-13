variable "acm_certificate_domain" {
  type = "string"
}

variable "alias_count" {
  type = "string"
}

variable "aliases" {
  type = "list"
}

variable "default_root_object" {
  type = "string"
  default = "index.html"
}

variable "distribution_name" {
  type = "string"
}

variable "hosted_zone_name" {
  type = "string"
}

variable "log_bucket" {
  type = "string"
}

variable "price_class" {
  type = "string"
  default = "PriceClass_100"
}