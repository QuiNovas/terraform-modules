locals {
  tags = "${merge(var.tags, map("Name", "${var.distribution_name}"))}"
}