data "aws_iam_policy_document" "redirector_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "lambda.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "redirector_assume_role" {
  assume_role_policy  = "${data.aws_iam_policy_document.redirector_assume_role.json}"
  name                = "${var.distribution_name}"
}

resource "aws_lambda_function" "redirector" {
  filename      = "${path.module}/default-index-redirect.zip"
  function_name = "${var.distribution_name}-default-index-redirector"
  handler       = "exports.handler"
  publish       = true
  role          = "${aws_iam_role.redirector_assume_role.arn}"
  runtime       = "nodejs6.10"
}

resource "aws_lambda_permission" "redirector" {
  action        = "lambda:GetFunction"
  function_name = "${aws_lambda_function.redirector.function_name}"
  principal     = "edgelambda.amazonaws.com"
  statement_id  = "AllowExecutionFromCloudFront"
}