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
