output "auth_token" {
  value = "${random_string.auth_token.result}"
}

output "primary_endpoint_address" {
  value = "${aws_elasticache_replication_group.redis.primary_endpoint_address}"
}

output "replication_group_id" {
  value = "${aws_elasticache_replication_group.redis.id}"
}

output "security_group_id" {
  value = "${aws_security_group.redis.id}"
}