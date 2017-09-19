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
  name                = "${var.name_prefix}-authorizer-invocation"
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
  name    = "${var.name_prefix}-authorizer-invocation"
  policy  = "${data.aws_iam_policy_document.authorizer_invocation.json}"
  role    = "${aws_iam_role.authorizer_invocation.id}"
}

data "aws_region" "current" {
  current = true
}

resource "aws_api_gateway_authorizer" "authorizer" {
  authorizer_credentials = "${aws_iam_role.authorizer_invocation.arn}"
  authorizer_result_ttl_in_seconds = 600
  authorizer_uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.authorizer.arn}/invocations"
  identity_source = "method.request.header.Authorization"
  identity_validation_expression = "^Basic .*"
  name = "${var.name_prefix}-basic-authentication-authorizer"
  rest_api_id = "${var.rest_api_id}"
}
