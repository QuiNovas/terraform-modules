output "master_password" {
  value = "${random_string.master_password.result}"
}