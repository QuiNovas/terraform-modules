resource "aws_subnet" "main" {
  availability_zone = "${var.availability_zones[count.index]}"
  cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, 3, count.index)}"
  count             = "${module.availability_zones_count.value}"
  tags {
    Name = "${var.name}-${var.availability_zones[count.index]}"
  }
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_redshift_subnet_group" "main" {
  name        = "${var.name}"
  subnet_ids  = [
    "${aws_subnet.main.*.id}"
  ]
  tags {
    Name = "${var.name}"
  }
}

resource "aws_kms_key" "main" {
  description         = "For Redshift cluster ${var.name}"
  is_enabled          = true
  enable_key_rotation = true
  tags {
    Name = "${var.name}"
  }
}

resource "aws_kms_alias" "main" {
  name          = "alias/${var.name}"
  target_key_id = "${aws_kms_key.main.id}"
}

resource "aws_s3_bucket" "audit" {
  bucket = "${var.name}-audit"
  lifecycle {
    prevent_destroy = true
  }
  lifecycle_rule {
    enabled = true
    expiration {
      days = 2555
    }
    id      = "all"
    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
  logging {
    target_bucket = "${var.log_bucket}"
    target_prefix = "s3/${var.name}/"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.main.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

data "aws_redshift_service_account" "current" {}

data "aws_iam_policy_document" "audit" {
  statement {
    actions   = [
      "s3:GetBucketAcl",
      "s3:PutObject*"
    ]
    principals {
      identifiers = [
        "${data.aws_redshift_service_account.current.arn}"
      ]
      type        = "AWS"
    }
    resources = [
      "${aws_s3_bucket.audit.arn}",
      "${aws_s3_bucket.audit.arn}/*"
    ]
    sid       = "AuditLogging"
  }
}

resource "aws_s3_bucket_policy" "audit" {
  bucket = "${aws_s3_bucket.audit.id}"
  policy = "${data.aws_iam_policy_document.audit.json}"
}

resource "aws_redshift_parameter_group" "main" {
  family  = "redshift-1.0"
  name    = "${var.name}"
  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }
  parameter {
    name  = "require_ssl"
    value = "true"
  }
  parameter {
    name  = "statement_timeout"
    value = "${var.statement_timeout}"
  }
  parameter {
    name  = "use_fips_ssl"
    value = "${var.use_fips_ssl}"
  }
}

resource "aws_redshift_cluster" "main" {
  automated_snapshot_retention_period = 7
  cluster_identifier                  = "${var.name}"
  cluster_parameter_group_name        = "${aws_redshift_parameter_group.main.name}"
  cluster_subnet_group_name           = "${aws_redshift_subnet_group.main.name}"
  cluster_type                        = "${var.number_of_nodes > 1 ? "multi-node" : "single-node"}"
  depends_on                          = [
    "aws_s3_bucket_policy.audit"
  ]
  encrypted                           = true
  iam_roles                           = [
    "${var.role_arns}"
  ]
  kms_key_id                          = "${aws_kms_key.main.arn}"
  logging {
    bucket_name = "${aws_s3_bucket.audit.id}"
    enable      = true
  }
  master_password                     = "${var.master_password}"
  master_username                     = "${var.master_username}"
  node_type                           = "${var.node_type}"
  number_of_nodes                     = "${var.number_of_nodes}"
  publicly_accessible                 = "${var.publicly_accessible}"
  tags {
    Name = "${var.name}"
  }
}