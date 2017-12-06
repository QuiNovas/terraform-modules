resource "aws_inspector_resource_group" "linux" {
  tags {
    Inspector  = "true"
    OS   = "linux"
  }
}

resource "aws_inspector_assessment_target" "linux" {
  name                = "${var.account_name}-linux"
  resource_group_arn  = "${aws_inspector_resource_group.linux.arn}"
}

resource "aws_inspector_assessment_template" "linux" {
  duration            = 3600
  name                = "${var.account_name}-linux"
  rules_package_arns  = [
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gBONHN9h",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7"
  ]
  target_arn          = "${aws_inspector_assessment_target.linux.arn}"
}