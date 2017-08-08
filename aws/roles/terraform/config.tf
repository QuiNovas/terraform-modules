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
      identifiers = "${var.allowed_user_arns}"
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "terraform" {
  assume_role_policy  = "${data.aws_iam_policy_document.terraform.json}"
  name                = "terraform"
  path                = "/user/"
}

resource "aws_iam_role_policy_attachment" "terraform" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role = "${aws_iam_role.terraform.name}"
}