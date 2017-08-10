output "bucket" {
  value = "${aws_s3_bucket.remote_state_backend.bucket}"
}

output "dynamodb_table" {
  value = "${aws_dynamodb_table.remote_state_backend.id}"
}

output "kms_key_arn" {
  value = "${aws_kms_key.remote_state_backend.arn}"
}