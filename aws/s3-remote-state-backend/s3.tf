resource "aws_s3_bucket" "remote_state_backend" {
  bucket = "${var.name_prefix}-remote-state-backend"
  lifecycle {
    prevent_destroy = true
  }
  logging {
    target_bucket = "${var.log_bucket_id}"
    target_prefix = "s3/${var.name_prefix}-remote-state-backend/"
  }
  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "remote_state_backend_bucket" {
  statement {
    actions = [
      "s3:*"
    ]
    condition {
      test = "Bool"
      values = [
        "false"
      ]
      variable = "aws:SecureTransport"
    }
    effect = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type = "AWS"
    }
    resources = [
      "${aws_s3_bucket.remote_state_backend.arn}",
      "${aws_s3_bucket.remote_state_backend.arn}/*"
    ]
    sid = "DenyUnsecuredTransport"
  }
  statement {
    actions = [
      "s3:PutObject"
    ]
    condition {
      test = "StringNotEquals"
      values = [
        "aws:kms"
      ]
      variable = "s3:x-amz-server-side-encryption"
    }
    effect = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type = "AWS"
    }
    resources = [
      "${aws_s3_bucket.remote_state_backend.arn}",
      "${aws_s3_bucket.remote_state_backend.arn}/*"
    ]
    sid = "DenyUnencryptedObjectPuts"
  }
}

resource "aws_s3_bucket_policy" "remote_state_backend" {
  bucket = "${aws_s3_bucket.remote_state_backend.id}"
  policy = "${data.aws_iam_policy_document.remote_state_backend_bucket.json}"
}