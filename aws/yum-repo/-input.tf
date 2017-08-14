variable "log_bucket_id" {
  type = "string"
}

variable "name_prefix" {
  type = "string"
}

variable "repo_locations" {
  type = "list"
}

variable "repo_whitelists" {
  type = "list"
  default = [
    "0.0.0.0/0"
  ]
}