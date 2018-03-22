output "distribution_id" {
  value = "${aws_cloudfront_distribution.distribution.id}"
}

output "origin_bucket" {
  value = "${aws_s3_bucket.origin.id}"
}

output "origin_bucket_arn" {
  value = "${aws_s3_bucket.origin.arn}"
}