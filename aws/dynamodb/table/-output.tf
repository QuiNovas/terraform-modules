output "arn" {
  value = "${aws_dynamodb_table.table.arn}"
}

output "hash_key" {
  value = "${aws_dynamodb_table.table.hash_key}"
}

output "name" {
  value = "${aws_dynamodb_table.table.name}"
}

output "stream_arn" {
  value = "${aws_dynamodb_table.table.stream_enabled == true ? aws_dynamodb_table.table.stream_arn : ""}"
}