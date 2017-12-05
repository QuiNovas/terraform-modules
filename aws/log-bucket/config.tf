resource "aws_s3_bucket" "log" {
  bucket  = "${var.name_prefix}-log"
  acl     = "log-delivery-write"
  lifecycle {
    prevent_destroy = true
  }
  lifecycle_rule {
    id      = "log"
    prefix  = "/"
    enabled = true

    transition {
      days = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 2555
    }
  }
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "log" {

  statement {
    actions   = [
      "s3:PutObject"
    ]
    principals {
      identifiers = [
        "${data.aws_elb_service_account.main.arn}"
      ]
      type = "AWS"
    }
    resources = [
      "${aws_s3_bucket.log.arn}/elb/*"
    ]
    sid       = "EnableELBLogging"
  }

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
      "${aws_s3_bucket.log.arn}",
      "${aws_s3_bucket.log.arn}/*"
    ]
    sid = "DenyUnsecuredTransport"
  }
}

resource "aws_s3_bucket_policy" "log" {
  bucket = "${aws_s3_bucket.log.id}"
  policy = "${data.aws_iam_policy_document.log.json}"
}
