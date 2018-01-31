output "arn" {
  value = "${aws_s3_bucket.lambda.arn}"
}

output "id" {
  value = "${aws_s3_bucket.lambda.id}"
}