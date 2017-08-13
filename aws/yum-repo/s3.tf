resource "aws_s3_bucket" "yum_repo" {
  acl = "public-read"
  bucket = "${var.name_prefix}-yum-repo"
  lifecycle {
    prevent_destroy = true
  }
  lifecycle_rule {
    id      = "versions"
    enabled = true
    noncurrent_version_expiration {
      days                          = 60
      expired_object_delete_marker  = true
    }
    noncurrent_version_transition {
      days          = 30
      storage_class = "GLACIER"
    }
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