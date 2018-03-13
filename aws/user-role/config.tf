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

module "policy_arn_count" {
  source  = "github.com/QuiNovas/terraform-modules//common/pass-thru-string"
  value   = "${length(var.policy_arns)}"
}

resource "aws_iam_role_policy_attachment" "role" {
  count = "${module.policy_arn_count.value}"
  policy_arn = "${var.policy_arns[count.index]}"
  role = "${aws_iam_role.role.name}"
}

module "group" {
  name                = "${var.name}"
  allowed_user_names  = ["${var.allowed_user_names}"]
  role_arns           = ["${aws_iam_role.role.arn}"]
  source              = "github.com/QuiNovas/terraform-modules//aws/assume-role-group"
}