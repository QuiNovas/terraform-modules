output "kms_key_arn" {
  value = "${aws_kms_key.main.arn}"
}

output "cluster_endpoint" {
  value = "${aws_redshift_cluster.main.endpoint}"
}

output "cluster_id" {
  value = "${aws_redshift_cluster.main.id}"
}

output "cluster_identifier" {
  value = "${aws_redshift_cluster.main.cluster_identifier}"
}

output "database_name" {
  value = "${aws_redshift_cluster.main.database_name}"
}

output "endpoint" {
  value = "${aws_redshift_cluster.main.endpoint}"
}

output "host" {
  value = "${element(split(":", aws_redshift_cluster.main.endpoint), 0)}"
}

output "port" {
  value = "${aws_redshift_cluster.main.port}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}