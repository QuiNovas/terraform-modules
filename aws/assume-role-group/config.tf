resource "aws_iam_group" "assume_role" {
  name = "${var.name}"
}

data "aws_iam_policy_document" "group" {
  "statement" {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "${var.role_arns}"
    ]
    sid = "AllowAssumingOfRole"
  }

  statement {
    actions = [
      "iam:ListAttachedRolePolicies"
    ]
    resources = [
      "${var.role_arns}"
    ]
    sid = "AllowListingOfRolePolicies"
  }
}

resource "aws_iam_group_policy" "group" {
  group   = "${aws_iam_group.assume_role.id}"
  name    = "role_access"
  policy  = "${data.aws_iam_policy_document.group.json}"
}

resource "aws_iam_group_membership" "group" {
  group = "${aws_iam_group.assume_role.name}"
  name  = "${var.name}-membership"
  users = [
    "${var.allowed_user_names}"
  ]
}