output "arn" {
  value = "${aws_secretsmanager_secret.secret.arn}"
}

output "id" {
  value = "${aws_secretsmanager_secret.secret.id}"
}

output "kms_key_arn" {
  value = "${aws_kms_key.secret.arn}"
}
