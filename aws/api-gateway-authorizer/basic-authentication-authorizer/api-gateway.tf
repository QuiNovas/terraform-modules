data "aws_iam_policy_document" "authorizer_invocation_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "apigateway.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "authorizer_invocation" {
  assume_role_policy  = "${data.aws_iam_policy_document.authorizer_invocation_assume_role.json}"
  name                = "${var.name_prefix}-basic-authentication-authorizer-invocation"
}

data "aws_iam_policy_document" "authorizer_invocation" {
  statement {
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "${aws_lambda_function.authorizer.arn}"
    ]
  }
}

resource "aws_iam_role_policy" "authorizer_invocation" {
  name    = "${var.name_prefix}-basic-authentication-authorizer-invocation"
  policy  = "${data.aws_iam_policy_document.authorizer_invocation.json}"
  role    = "${aws_iam_role.authorizer_invocation.id}"
}

data "aws_region" "current" {
  current = true
}
