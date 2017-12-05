resource "aws_config_config_rule" "restricted_ssh" {
  depends_on  = [
    "aws_config_configuration_recorder.config"
  ]
  name        = "restricted-ssh"
  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
}
