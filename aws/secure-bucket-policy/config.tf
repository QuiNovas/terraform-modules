data "aws_iam_policy_document" "secure_bucket_policy" {
  statement {
    actions   = [
      "s3:*"
    ]
    condition {
      test      = "Bool"
      values    = [
        "false"
      ]
      variable  = "aws:SecureTransport"
    }
    effect    = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type        = "AWS"
    }
    resources = [
      "${var.bucket_arn}",
      "${var.bucket_arn}/*"
    ]
    sid       = "DenyUnsecuredTransport"
  }
  statement {
    actions   = [
      "s3:PutObject"
    ]
    condition {
      test      = "StringNotEquals"
      values    = [
        "${var.kms_key_arns}"
      ]
      variable  = "s3:x-amz-server-side-encryption-aws-kms-key-id"
    }
    effect    = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type        = "AWS"
    }
    resources = [
      "${var.bucket_arn}",
      "${var.bucket_arn}/*"
    ]
    sid       = "DenyIncorrectEncryptionHeader"
  }
  statement {
    actions   = [
      "s3:PutObject"
    ]
    condition {
      test      = "Null"
      values    = [
        "true"
      ]
      variable  = "s3:x-amz-server-side-encryption"
    }
    effect    = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type        = "AWS"
    }
    resources = [
      "${var.bucket_arn}",
      "${var.bucket_arn}/*"
    ]
    sid       = "DenyUnencryptedObjectUploads"
  }
}
