resource "aws_iam_user" "remote_state_backend" {
  count = "${var.user_name_count}"
  name  = "${var.user_names[count.index]}"
}