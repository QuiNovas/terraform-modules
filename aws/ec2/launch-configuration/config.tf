data "aws_iam_policy_document" "assume_role_policy" {
  statement {
     actions = [
       "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "ec2.amazonaws.com"
      ]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "launch_config" {
  assume_role_policy  = "${data.aws_iam_policy_document.assume_role_policy.json}"
  name                = "${var.name}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  policy_arn  = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
  role        = "${aws_iam_role.launch_config.name}"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role        = "${aws_iam_role.launch_config.name}"
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  count       = "${local.policy_arns_count}"
  policy_arn  = "${var.policy_arns[count.index]}"
  role        = "${aws_iam_role.launch_config.name}"
}

resource "aws_iam_instance_profile" "launch_config" {
  name = "${var.name}"
  role = "${aws_iam_role.launch_config.name}"
}

resource "aws_launch_configuration" "launch_config" {
  associate_public_ip_address = "${var.associate_public_ip_address}"
  ebs_block_device            = [
    "${var.ebs_block_devices}"
  ]
  ebs_optimized               = "${contains(local.ebs_optimized_instance_types, var.instance_type)}"
  enable_monitoring           = true
  ephemeral_block_device      = [
    "${var.ephemeral_block_devices}"
  ]
  iam_instance_profile        = "${aws_iam_instance_profile.launch_config.name}"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  lifecycle {
    create_before_destroy = true
  }
  name_prefix                 = "${var.name}"
  placement_tenancy           = "${var.placement_tenancy}"
  root_block_device           = [
    "${var.root_block_device}"
  ]
  security_groups             = [
    "${var.security_groups}"
  ]
  user_data                   = "${var.user_data}"
}
