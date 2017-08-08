data "aws_iam_policy_document" "role" {
  "statement" {
    actions = [
      "sts:AssumeRole"
    ]
    condition {
      test      = "Bool"
      values    = [
        "true"
      ]
      variable  = "aws:MultiFactorAuthPresent"
    }
    principals {
      identifiers = ["${var.allowed_user_arns}"]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "role" {
  assume_role_policy  = "${data.aws_iam_policy_document.role.json}"
  name                = "${var.name}"
}

resource "aws_iam_role_policy_attachment" "role" {
  count = "${var.policy_arn_count}"
  policy_arn = "${var.policy_arns[count.index]}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_group" "group" {
  name = "${var.name}"
}

data "aws_iam_policy_document" "group" {
  "statement" {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "${aws_iam_role.role.arn}"
    ]
    sid = "AllowAssumingOfRole"
  }

  statement {
    actions = [
      "iam:ListAttachedRolePolicies"
    ]
    resources = [
      "${aws_iam_role.role.arn}"
    ]
    sid = "AllowListingOfRolePolicies"
  }
}

resource "aws_iam_group_policy" "group" {
  group   = "${aws_iam_group.group.id}"
  name    = "role_access"
  policy  = "${data.aws_iam_policy_document.group.json}"
}

resource "aws_iam_group_membership" "group" {
  group = "${aws_iam_group.group.name}"
  name  = "${var.name}-membership"
  users = [
    "${var.allowed_user_names}"
  ]
}