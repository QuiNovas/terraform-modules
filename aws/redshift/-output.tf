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

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}