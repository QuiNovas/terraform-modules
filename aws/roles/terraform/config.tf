data "aws_iam_policy_document" "terraform" {
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

resource "aws_iam_role" "terraform" {
  assume_role_policy  = "${data.aws_iam_policy_document.terraform.json}"
  name                = "terraform"
}

resource "aws_iam_role_policy_attachment" "terraform" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role = "${aws_iam_role.terraform.name}"
}

resource "aws_iam_group" "terraform" {
  name = "terraform"
}

data "aws_iam_policy_document" "terraform" {
  "statement" {
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "${aws_iam_role.terraform.arn}"
    ]
    sid = "AllowAssumingOfRole"
  }

  statement {
    actions = [
      "iam:ListAttachedRolePolicies"
    ]
    resources = [
      "${aws_iam_role.terraform.arn}"
    ]
    sid = "AllowListingOfRolePolicies"
  }
}

resource "aws_iam_group_policy" "terraform" {
  group   = "${aws_iam_group.terraform.id}"
  name    = "role_access"
  policy  = "${data.aws_iam_policy_document.terraform.json}"
}

resource "aws_iam_group_membership" "terraform" {
  group = "${aws_iam_group.terraform.name}"
  name  = "terraform-membership"
  users = [
    "${var.allowed_user_names}"
  ]
}