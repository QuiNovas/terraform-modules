output "authorizer_credentials" {
  value = "${aws_iam_role.authorizer_invocation.arn}"
}

data "aws_region" "current" {
  current = true
}

output "authorizer_uri" {
  value = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.authorizer.arn}/invocations"
}

output "lambda_function_arn" {
  value = "${aws_lambda_function.authorizer.arn}"
}

output "users_table_name" {
  value = "${aws_dynamodb_table.users.name}"
}