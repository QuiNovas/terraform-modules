resource "aws_inspector_resource_group" "windows" {
  tags {
    Name  = "inspector"
    Env   = "windows"
  }
}

resource "aws_inspector_assessment_target" "windows" {
  name                = "${var.account_name}-windows"
  resource_group_arn  = "${aws_inspector_resource_group.windows.arn}"
}

resource "aws_inspector_assessment_template" "windows" {
  duration            = 3600
  name                = "${var.account_name}-windows"
  rules_package_arns  = []
  target_arn          = "${aws_inspector_assessment_target.windows.arn}"
}