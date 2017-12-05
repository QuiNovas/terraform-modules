resource "aws_config_config_rule" "iam_password_policy" {
  depends_on  = [
    "aws_config_configuration_recorder.config"
  ]
  input_parameters = <<PARAMS
{
  "RequireUppercaseCharacters": "true",
  "RequireLowercaseCharacters": "true",
  "RequireSymbols": "true",
  "RequireNumbers": "true",
  "MinimumPasswordLength": "30",
  "PasswordReusePrevention": "24",
  "MaxPasswordAge": "30"
}
PARAMS
  name        = "iam-password-policy"
  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }
}

resource "aws_config_config_rule" "root_account_mfa_enabled" {
  depends_on  = [
    "aws_config_configuration_recorder.config"
  ]
  name        = "root-account-mfa-enabled"
  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }
}
