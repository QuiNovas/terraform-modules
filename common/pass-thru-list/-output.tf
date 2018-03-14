output "count" {
  value = "${length(var.value)}"
}

output "value" {
  value = "${var.value}"
}
