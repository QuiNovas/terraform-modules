locals {
  tags = "${merge(var.tags, map("Name", "${var.name}"))}"
}