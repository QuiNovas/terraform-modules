output "json" {
  value = "${data.aws_iam_policy_document.secure_bucket_policy.json}"
}