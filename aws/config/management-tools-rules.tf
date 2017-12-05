resource "aws_config_config_rule" "cloudtrail_enabled" {
  depends_on  = [
    "aws_config_configuration_recorder.config"
  ]
  name        = "cloudtrail-enabled"
  source {
    owner             = "AWS"
    source_identifier = "CLOUD_TRAIL_ENABLED"
  }
}
