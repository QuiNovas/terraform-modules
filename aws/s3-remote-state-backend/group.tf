resource "aws_iam_group" "remote_state_backend" {
  name = "remote-state-backend"
}

data "aws_iam_policy_document" "remote_state_backend_group" {
  statement {
    actions   = [
      "s3:Get*",
      "s3:List*",
      "s3:Put*"
    ]
    resources = [
      "${aws_s3_bucket.remote_state_backend.arn}",
      "${aws_s3_bucket.remote_state_backend.arn}/*"
    ]
    sid       = "AllowAccessToRemoteStateBackend"
  }
  statement {
    actions   = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*"
    ]
    resources = [
      "${aws_kms_key.remote_state_backend.arn}"
    ]
    sid       = "AllowUseOfRemoteStateBackendKMSKey"
  }
  statement {
    actions   = [
      "dynamodb:Batch*",
      "dynamodb:DeleteItem",
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "${aws_dynamodb_table.remote_state_backend.arn}"
    ]
    sid       = "AllowAccessToLockTable"
  }
}

resource "aws_iam_group_policy" "remote_state_backend" {
  name    = "remote-state-backend-access"
  group   = "${aws_iam_group.remote_state_backend.id}"
  policy  = "${data.aws_iam_policy_document.remote_state_backend_group.json}"
}

resource "aws_iam_group_membership" "remote_state_backend" {
  group = "${aws_iam_group.remote_state_backend.name}"
  name  = "remote-state-backend-membership"
  users = ["${aws_iam_user.remote_state_backend.*.name}"]
}