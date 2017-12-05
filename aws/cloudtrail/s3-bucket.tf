resource "aws_s3_bucket" "cloudtrail" {
  acl     = "log-delivery-write"
  bucket  = "${var.account_name}-cloudtrail"

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
    target_prefix = "s3/${var.account_name}-cloudtrail/"
  }
}

data "aws_iam_policy_document" "cloudtrail_s3" {

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
      type = "Service"
    }
    resources = [
      "${aws_s3_bucket.cloudtrail.arn}"
    ]
    sid = "CloudTrail Acl Check"
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    condition {
      test = "StringEquals"
      values = [
        "bucket-owner-full-control"
      ]
      variable = "s3:x-amz-acl"
    }
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
      type = "Service"
    }
    resources = [
      "${aws_s3_bucket.cloudtrail.arn}/*"
    ]
    sid = "CloudTrail Write"
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
      "${aws_s3_bucket.cloudtrail.arn}",
      "${aws_s3_bucket.cloudtrail.arn}/*"
    ]
    sid = "DenyUnsecuredTransport"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = "${aws_s3_bucket.cloudtrail.id}"
  policy = "${data.aws_iam_policy_document.cloudtrail_s3.json}"
}