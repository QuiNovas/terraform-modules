resource "aws_kms_key" "remote_state_backend" {
  description         = "Key for all remote state backends"
  enable_key_rotation = true
}

resource "aws_kms_alias" "remote_state_backend" {
  name          = "alias/${var.name_prefix}-remote-state-backend"
  target_key_id = "${aws_kms_key.remote_state_backend.key_id}"
}