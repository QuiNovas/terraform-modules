resource "aws_elasticache_subnet_group" "redis" {
  name        = "${var.name_prefix}-redis"
  subnet_ids  = [
    "${var.subnet_ids}"
  ]
}

resource "aws_security_group" "redis" {
  name    = "${var.name_prefix}-redis"
  tags    = "${merge(var.tags, map("Name", "${var.name_prefix}-redis"))}"
  vpc_id  = "${var.vpc_id}"
}

resource "aws_security_group_rule" "self_ingress_redis" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.redis.id}"
  self              = true
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "all_egress_redis" {
  cidr_blocks       = [
    "0.0.0.0/0"
  ]
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.redis.id}"
  to_port           = 0
  type              = "egress"
}

resource "random_string" "auth_token" {
  length            = 64
  lower             = true
  number            = true
  special           = true
  override_special  = "!#$%&*()-_=+[]{}<>:?"
  upper             = true
}

resource "aws_elasticache_replication_group" "redis" {
  at_rest_encryption_enabled    = true
  auth_token                    = "${random_string.auth_token.result}"
  auto_minor_version_upgrade    = false
  automatic_failover_enabled    = true
  engine                        = "redis"
  engine_version                = "3.2.6"
  lifecycle {
    ignore_changes = ["number_cache_clusters"]
  }
  node_type                     = "cache.m3.medium"
  number_cache_clusters         = 2
  port                          = 6379
  replication_group_description = "${var.replication_name_prefix}-redis"
  replication_group_id          = "${var.replication_name_prefix}-redis"
  security_group_ids            = [
    "${aws_security_group.redis.id}"
  ]
  snapshot_retention_limit      = 7
  snapshot_window               = "06:00-07:00"
  subnet_group_name             = "${aws_elasticache_subnet_group.redis.name}"
  tags                          = "${merge(var.tags, map("Name", "${var.name_prefix}-redis"))}"
  transit_encryption_enabled    = true
}