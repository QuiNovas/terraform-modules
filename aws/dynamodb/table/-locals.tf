locals {
  global_secondary_indexes_count  = "${length(var.global_secondary_indexes)}"
  tags                            = "${merge(var.tags, map("Name", "${var.name}"))}"
}
