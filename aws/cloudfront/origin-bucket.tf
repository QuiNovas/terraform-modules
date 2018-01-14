resource "aws_s3_bucket" "origin" {
  bucket = "${var.distribution_name}"
  lifecycle {
    prevent_destroy = true
  }
  logging {
    target_bucket = "${var.log_bucket}"
    target_prefix = "s3/${var.distribution_name}/"
  }
  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "origin_bucket_policy" {
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
      "${aws_s3_bucket.origin.arn}",
      "${aws_s3_bucket.origin.arn}/*"
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
        "AES256"
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
      "${aws_s3_bucket.origin.arn}",
      "${aws_s3_bucket.origin.arn}/*"
    ]
    sid = "DenyIncorrectEncryptionHeader"
  }
  statement {
    actions = [
      "s3:PutObject"
    ]
    condition {
      test = "Null"
      values = [
        "true"
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
      "${aws_s3_bucket.origin.arn}",
      "${aws_s3_bucket.origin.arn}/*"
    ]
    sid = "DenyUnencryptedObjectUploads"
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    principals {
      identifiers = [
        "${aws_cloudfront_origin_access_identity.origin.iam_arn}"
      ]
      type = "AWS"
    }
    resources = [
        "${aws_s3_bucket.origin.arn}",
        "${aws_s3_bucket.origin.arn}/*"
    ]
    sid = "AllowCloudFront"
  }
}

resource "aws_s3_bucket_policy" "origin" {
  bucket = "${aws_s3_bucket.origin.id}"
  policy = "${data.aws_iam_policy_document.origin_bucket_policy.json}"
}
