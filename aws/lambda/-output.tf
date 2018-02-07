output "arn" {
  value = "${aws_lambda_function.function.arn}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.function.invoke_arn}"
}

output "name" {
  value = "${aws_lambda_function.function.function_name}"
}

output "qualified_arn" {
  value = "${aws_lambda_function.function.qualified_arn}"
}
