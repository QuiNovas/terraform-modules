output "endpoint" {
  value = "${aws_db_instance.rds.endpoint}"
}

output "master_password" {
  value = "${random_string.master_password.result}"
}

output "security_group_id" {
  value = "${aws_security_group.rds.id}"
}