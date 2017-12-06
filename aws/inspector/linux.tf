resource "aws_inspector_resource_group" "linux" {
  tags {
    Name  = "inspector"
    Env   = "linux"
  }
}

resource "aws_inspector_assessment_target" "linux" {
  name                = "${var.account_name}-linux"
  resource_group_arn  = "${aws_inspector_resource_group.windows.arn}"
}

resource "aws_inspector_assessment_template" "linux" {
  duration            = 3600
  name                = "${var.account_name}-linux"
  rules_package_arns  = []
  target_arn          = "${aws_inspector_assessment_target.windows.arn}"
}