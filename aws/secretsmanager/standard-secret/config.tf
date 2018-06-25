resource "aws_kms_key" "secret" {
  description         = "Key for secret ${var.name}"
  enable_key_rotation = true
}

resource "aws_kms_alias" "secret" {
  name          = "alias/${var.name}"
  target_key_id = "${aws_kms_key.secret.key_id}"
}

resource "aws_secretsmanager_secret" "secret" {
  description = "${var.description}"
  kms_key_id  = "${aws_kms_key.secret.key_id}"
  name        = "${var.name}"
  tags        = "${var.tags}"
}