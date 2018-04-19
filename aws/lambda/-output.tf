output "arn" {
  value = "${aws_lambda_function.function.arn}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.function.invoke_arn}"
}

output "invoke_policy_arn" {
  value = "${aws_iam_policy.invoke_function.arn}"
}

output "name" {
  value = "${aws_lambda_function.function.function_name}"
}

output "qualified_arn" {
  value = "${aws_lambda_function.function.qualified_arn}"
}

output "qualified_invoke_arn" {
  value = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.function.qualified_arn}/invocations"
}
