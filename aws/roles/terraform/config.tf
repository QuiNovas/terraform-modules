data "aws_iam_policy_document" "terraform_role" {
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

resource "aws_iam_role" "terraform_role" {
  assume_role_policy  = "${data.aws_iam_policy_document.terraform_role.json}"
  name                = "terraform"
}

resource "aws_iam_role_policy_attachment" "terraform_role" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role = "${aws_iam_role.terraform_role.name}"
}

resource "aws_iam_group" "terraform_group" {
  name = "terraform"
}

data "aws_iam_policy_document" "terraform_group" {
  "statement" {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "${aws_iam_role.terraform_role.arn}"
    ]
    sid = "AllowAssumingOfRole"
  }

  statement {
    actions = [
      "iam:ListAttachedRolePolicies"
    ]
    resources = [
      "${aws_iam_role.terraform_role.arn}"
    ]
    sid = "AllowListingOfRolePolicies"
  }
}

resource "aws_iam_group_policy" "terraform_group" {
  group   = "${aws_iam_group.terraform_group.id}"
  name    = "role_access"
  policy  = "${data.aws_iam_policy_document.terraform_group.json}"
}

resource "aws_iam_group_membership" "terraform_group" {
  group = "${aws_iam_group.terraform_group.name}"
  name  = "terraform-membership"
  users = [
    "${var.allowed_user_names}"
  ]
}