resource "aws_s3_bucket" "config" {
  acl     = "log-delivery-write"
  bucket  = "${var.account_name}-config"

  lifecycle_rule {
    id = "log"
    prefix = "/"
    enabled = true

    transition {
      days = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 2555
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  logging {
    target_bucket = "${var.log_bucket}"
    target_prefix = "s3/${var.account_name}-config/"
  }
}

data "aws_iam_policy_document" "config" {

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
      "${aws_s3_bucket.config.arn}",
      "${aws_s3_bucket.config.arn}/*"
    ]
    sid = "DenyUnsecuredTransport"
  }
}

resource "aws_s3_bucket_policy" "config" {
  bucket = "${aws_s3_bucket.config.id}"
  policy = "${data.aws_iam_policy_document.config.json}"
}
