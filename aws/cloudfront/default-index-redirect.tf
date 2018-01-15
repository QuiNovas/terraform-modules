data "aws_iam_policy_document" "redirector_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "redirector" {
  assume_role_policy  = "${data.aws_iam_policy_document.redirector_assume_role.json}"
  name                = "${var.distribution_name}-default-index-redirector"
}

resource "aws_cloudwatch_log_group" "redirector_log_group" {
  name              = "/aws/lambda/${var.distribution_name}-default-index-redirector"
  retention_in_days = 7
}

data "aws_iam_policy_document" "redirector" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.redirector_log_group.arn}"
    ]
    sid       = "AllowLogCreation"
  }
}

resource "aws_iam_role_policy" "redirector" {
  name    = "${var.distribution_name}-default-index-redirector"
  policy  = "${data.aws_iam_policy_document.redirector.json}"
  role    = "${aws_iam_role.redirector.id}"
}

resource "aws_lambda_function" "redirector" {
  filename      = "${path.module}/default-index-redirect.zip"
  function_name = "${var.distribution_name}-default-index-redirector"
  handler       = "exports.handler"
  publish       = true
  role          = "${aws_iam_role.redirector.arn}"
  runtime       = "nodejs6.10"
}

resource "aws_lambda_permission" "redirector" {
  action        = "lambda:GetFunction"
  function_name = "${aws_lambda_function.redirector.function_name}"
  principal     = "edgelambda.amazonaws.com"
  statement_id  = "AllowExecutionFromCloudFront"
}