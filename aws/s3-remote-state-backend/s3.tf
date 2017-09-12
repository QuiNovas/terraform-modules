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

module "remote_state_backend_bucket_policy" {
  bucket_arn    = "${aws_s3_bucket.remote_state_backend.arn}"
  kms_key_arns  = ["${aws_kms_key.remote_state_backend.arn}"]
  source        = "github.com/QuiNovas/terraform-modules//aws/secure-bucket-policy"
}

resource "aws_s3_bucket_policy" "remote_state_backend" {
  bucket = "${aws_s3_bucket.remote_state_backend.id}"
  policy = "${module.remote_state_backend_bucket_policy.json}"
}