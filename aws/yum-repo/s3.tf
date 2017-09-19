resource "aws_s3_bucket" "yum_repo" {
  acl = "public-read"
  bucket = "${var.name_prefix}-yum-repo"
  lifecycle {
    prevent_destroy = true
  }
  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 7
    id      = "versions"
    enabled = true
    expiration {
      expired_object_delete_marker = true
    }
    noncurrent_version_expiration {
      days = 60
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
  logging {
    target_bucket = "${var.log_bucket_id}"
    target_prefix = "s3/${var.name_prefix}-yum-repo/"
  }
  versioning {
    enabled = true
  }
  website {
    index_document = "index.html"
  }
}

data "aws_iam_policy_document" "yum_repo_s3" {
  statement {
    actions   = [
      "s3:GetObject*",
      "s3:ListBucket",
      "s3:ListBucketVersions"
    ]
    condition {
      test = "IpAddress"
      values = ["${var.repo_whitelists}"]
      variable = "aws:SourceIp"
    }
    principals {
      identifiers = [
        "*"
      ]
      type = "AWS"
    }
    resources = [
      "${aws_s3_bucket.yum_repo.arn}",
      "${aws_s3_bucket.yum_repo.arn}/*"
    ]
    sid       = "AllowAnonymousReads"
  }
}

resource "aws_s3_bucket_policy" "yum_repo" {
  bucket = "${aws_s3_bucket.yum_repo.id}"
  policy = "${data.aws_iam_policy_document.yum_repo_s3.json}"
}

resource "aws_s3_bucket_notification" "yum_repo" {
  depends_on  = ["aws_lambda_permission.repo_watcher"]
  bucket      = "${aws_s3_bucket.yum_repo.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.repo_watcher.arn}"
    events              = [
      "s3:ObjectCreated:*",
      "s3:ObjectRemoved:*"
    ]
    filter_suffix       = ".rpm"
  }
}