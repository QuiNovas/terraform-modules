resource "aws_db_subnet_group" "rds" {
  name        = "${var.name}"
  subnet_ids  = ["${var.subnet_ids}"]
  tags        = "${local.tags}"
}

resource "aws_db_parameter_group" "rds" {
  family  = "postgres10"
  name    = "${var.name}-postgres10"
  parameter = [
    "${var.parameters}"
  ]
  tags    = "${local.tags}"
}

resource "aws_kms_key" "rds" {
  description         = "${var.name}"
  enable_key_rotation = true
  is_enabled          = true
  tags                = "${local.tags}"
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.name}"
  target_key_id = "${aws_kms_key.rds.id}"
}

resource "random_string" "master_password" {
  length            = 64
  lower             = true
  number            = true
  special           = true
  override_special  = "!#$%&*()-_=+[]{}<>:?"
  upper             = true
}

resource "aws_security_group" "rds" {
  name    = "${var.name}"
  tags    = "${local.tags}"
  vpc_id  = "${var.vpc_id}"
}

resource "aws_security_group_rule" "self_ingress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.rds.id}"
  self              = true
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "all_egress" {
  cidr_blocks       = [
    "0.0.0.0/0"
  ]
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.rds.id}"
  to_port           = 0
  type              = "egress"
}

data "aws_iam_policy_document" "monitoring_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "monitoring.rds.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "monitoring" {
  assume_role_policy  = "${data.aws_iam_policy_document.monitoring_assume_role.json}"
  name                = "${var.name}-monitoring"
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role        = "${aws_iam_role.monitoring.name}"
}


resource "aws_db_instance" "rds" {
  allocated_storage           = 100
  auto_minor_version_upgrade  = true
  backup_retention_period     = 7
  backup_window               = "05:00-05:30"
  copy_tags_to_snapshot       = true
  db_subnet_group_name        = "${aws_db_subnet_group.rds.name}"
  engine                      = "postgres"
  engine_version              = "10.1"
  final_snapshot_identifier   = "${var.name}-final"
  identifier                  = "${var.name}"
  instance_class              = "${var.instance_class}"
  kms_key_id                  = "${aws_kms_key.rds.arn}"
  lifecycle {
    prevent_destroy = true
  }
  monitoring_interval         = 60
  monitoring_role_arn         = "${aws_iam_role.monitoring.arn}"
  multi_az                    = true
  name                        = "${var.database_name}"
  parameter_group_name        = "${aws_db_parameter_group.rds.name}"
  password                    = "${random_string.master_password.result}"
  storage_encrypted           = true
  storage_type                = "gp2"
  tags                        = "${local.tags}"
  username                    = "${var.username}"
  vpc_security_group_ids      = [
    "${aws_security_group.rds.id}"
  ]
}
