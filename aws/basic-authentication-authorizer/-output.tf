output "groups_table_arn" {
  value = "${aws_dynamodb_table.groups.arn}"
}

output "lambda_function_arn" {
  value = "${aws_lambda_function.authorizer.arn}"
}

output "users_table_arn" {
  value = "${aws_dynamodb_table.users.arn}"
}