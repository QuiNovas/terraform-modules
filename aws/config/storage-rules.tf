resource "aws_config_config_rule" "s3_bucket_logging_enabled" {
  depends_on  = [
    "aws_config_configuration_recorder.config"
  ]
  name        = "s3-bucket-logging-enabled"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_LOGGING_ENABLED"
  }
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  depends_on  = [
    "aws_config_configuration_recorder.config"
  ]
  name        = "s3-bucket-public-read-prohibited"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}

resource "aws_config_config_rule" "s3_bucket_public_write_prohibited" {
  depends_on  = [
    "aws_config_configuration_recorder.config"
  ]
  name        = "s3-bucket-public-write-prohibited"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }
}

resource "aws_config_config_rule" "s3_bucket_ssl_requests_only" {
  depends_on  = [
    "aws_config_configuration_recorder.config"
  ]
  name        = "s3-bucket-ssl-requests-only"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }
}
