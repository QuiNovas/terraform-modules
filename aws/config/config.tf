data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "config.amazonaws.com"
      ]
      type  = "Service"
    }
  }
}

resource "aws_iam_role" "config_role" {
  assume_role_policy  = "${data.aws_iam_policy_document.assume_role_policy.json}"
  name                = "${var.account_name}-config"
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${var.config_delivery_bucket_arn}",
      "${var.config_delivery_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "config" {
  policy  = "${data.aws_iam_policy_document.role_policy.json}"
  role    = "${aws_iam_role.config_role.id}"
}

resource "aws_iam_role_policy_attachment" "config" {
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
  role        = "${aws_iam_role.config_role.name}"
}

resource "aws_config_configuration_recorder" "config" {
  name      = "${var.account_name}"
  recording_group {
    include_global_resource_types = true
  }
  role_arn  = "${aws_iam_role.config_role.arn}"
}

resource "aws_sns_topic" "config" {
  name = "${var.account_name}-config"
}

resource "aws_config_delivery_channel" "config" {
  depends_on      = [
    "aws_config_configuration_recorder.config"
  ]
  name            = "${var.account_name}"
  s3_bucket_name  = "${var.config_delivery_bucket}"
  s3_key_prefix   = "config"
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  sns_topic_arn   = "${aws_sns_topic.config.arn}"
}

resource "aws_config_configuration_recorder_status" "config" {
  depends_on  = [
    "aws_config_delivery_channel.config"
  ]
  is_enabled  = false
  name        = "${aws_config_configuration_recorder.config.name}"
}
