resource "aws_inspector_resource_group" "windows" {
  tags {
    Inspector  = "true"
    OS   = "windows"
  }
}

resource "aws_inspector_assessment_target" "windows" {
  name                = "${var.account_name}-windows"
  resource_group_arn  = "${aws_inspector_resource_group.windows.arn}"
}

resource "aws_inspector_assessment_template" "windows" {
  duration            = 3600
  name                = "${var.account_name}-windows"
  rules_package_arns  = [
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gBONHN9h",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8"
  ]
  target_arn          = "${aws_inspector_assessment_target.windows.arn}"
}