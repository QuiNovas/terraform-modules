output "arn" {
  value = "${aws_dynamodb_table.groups.arn}"
}

output "name" {
  value = "${aws_dynamodb_table.groups.name}"
}
