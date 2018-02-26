data "aws_iam_policy_document" "authorizer_assume_role" {
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

resource "aws_iam_role" "authorizer" {
  name = "${var.name_prefix}-api-key-authorizer"
  assume_role_policy = "${data.aws_iam_policy_document.authorizer_assume_role.json}"
}

resource "aws_cloudwatch_log_group" "authorizer_log_group" {
  name              = "/aws/lambda/${var.name_prefix}-api-key-authorizer"
  retention_in_days = 7
}

data "aws_iam_policy_document" "authorizer" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.authorizer_log_group.arn}"
    ]
    sid       = "AllowLogCreation"
  }
  statement {
    actions = [
      "dynamodb:*GetItem"
    ]
    resources = [
      "${aws_dynamodb_table.apikeys.arn}",
      "${var.groups_table_arn}"
    ]
  }
}

resource "aws_iam_role_policy" "authorizer" {
  name    = "${var.name_prefix}-api-key-authorizer"
  policy  = "${data.aws_iam_policy_document.authorizer.json}"
  role    = "${aws_iam_role.authorizer.id}"
}

data "aws_s3_bucket_object" "api_key_authorizer" {
  bucket  = "lambdalambdalambda-repo"
  key     = "quinovas/api-key-authorizer/api-key-authorizer-0.0.2.zip"
}

resource "aws_lambda_function" "authorizer" {
  depends_on = ["aws_cloudwatch_log_group.authorizer_log_group"]
  environment {
    variables {
      API_KEYS_TABLE_NAME = "${aws_dynamodb_table.apikeys.name}"
      GROUPS_TABLE_NAME   = "${var.groups_table_name}"
    }
  }
  function_name     = "${var.name_prefix}-api-key-authorizer"
  handler           = "function.handler"
  role              = "${aws_iam_role.authorizer.arn}"
  runtime           = "python2.7"
  s3_bucket         = "${data.aws_s3_bucket_object.api_key_authorizer.bucket}"
  s3_key            = "${data.aws_s3_bucket_object.api_key_authorizer.key}"
  s3_object_version = "${data.aws_s3_bucket_object.api_key_authorizer.version_id}"
}
