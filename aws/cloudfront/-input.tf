variable "acm_certificate_arn" {
  type = "string"
}

variable "aliases" {
  type = "list"
}

variable "bucket_name" {
  default = ""
  type    = "string"
}

variable "comment" {
  default = ""
  type    = "string"
}

variable "custom_error_responses" {
  default = []
  type    = "list"
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

variable "ordered_cache_behaviors" {
  default = []
  type    = "list"
}

variable "price_class" {
  default = "PriceClass_100"
  type    = "string"
}

variable "tags" {
  default = {}
  type    = "map"
}

variable "web_acl_id" {
  default = ""
  type    = "string"
}