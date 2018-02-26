output "authorizer_credentials" {
  value = "${aws_iam_role.authorizer_invocation.arn}"
}

output "authorizer_uri" {
  value = "${aws_lambda_function.authorizer.invoke_arn}"
}

output "lambda_function_arn" {
  value = "${aws_lambda_function.authorizer.arn}"
}

output "users_table_name" {
  value = "${aws_dynamodb_table.users.name}"
}