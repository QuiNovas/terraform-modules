resource "aws_kms_key" "workmail" {
  description         = "workmail key for ${var.domain}"
  enable_key_rotation = true
}

resource "aws_kms_alias" "workmail" {
  name          = "alias/${replace(var.domain, ".", "_")}-workmail"
  target_key_id = "${aws_kms_key.workmail.key_id}"
}
