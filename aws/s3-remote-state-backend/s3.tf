resource "aws_s3_bucket" "remote_state_backend" {
  bucket = "${var.name_prefix}-remote-state-backend"
  lifecycle {
    prevent_destroy = true
  }
  logging {
    target_bucket = "${var.log_bucket_id}"
    target_prefix = "s3/${var.name_prefix}-remote-state-backend/"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.remote_state_backend.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = true
  }
}

module "remote_state_backend_bucket_policy" {
  bucket_arn    = "${aws_s3_bucket.remote_state_backend.arn}"
  kms_key_arns  = ["${aws_kms_key.remote_state_backend.arn}"]
  source        = "github.com/QuiNovas/terraform-modules//aws/secure-bucket-policy?ref=v1.0.13"
}

resource "aws_s3_bucket_policy" "remote_state_backend" {
  bucket = "${aws_s3_bucket.remote_state_backend.id}"
  policy = "${module.remote_state_backend_bucket_policy.json}"
}