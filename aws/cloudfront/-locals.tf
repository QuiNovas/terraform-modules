locals {
  bucket_name = "${var.bucket_name == "" ? var.distribution_name : var.bucket_name}"
  tags = "${merge(var.tags, map("Name", "${var.distribution_name}"))}"
}