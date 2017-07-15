data "aws_caller_identity" "current" {}

resource "aws_iam_user" "user" {
  name = "${var.user_name}"
  path = "${var.user_path}"
}

resource "aws_iam_user_ssh_key" "user" {
  count      = "${var.user_ssh_pub == "none" ? 0 : 1}"
  username   = "${aws_iam_user.user.name}"
  encoding   = "SSH"
  public_key = "${var.user_ssh_pub}"
}

data "aws_iam_policy_document" "user" {

  statement {
    actions   = [
      "iam:*AccessKey*",
      "iam:GenerateCredentialReport",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:*LoginProfile*",
      "iam:*SSHPublicKey*"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user${var.user_path}${var.user_name}"
    ]
    sid       = "ManageLoginProfile"
  }

  statement {
    actions   = [
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
      "iam:ListAccount*",
      "iam:ListUsers"
    ]
    resources = [
      "*"
    ]
    sid       = "AllowViewingOfProfiles"
  }

  statement {
    actions   = [
      "iam:CreateVirtualMFADevice",
      "iam:DeactivateMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ListMFADevices",
      "iam:ResyncMFADevice"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/${var.user_name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user${var.user_path}${var.user_name}"
    ]
    sid       = "AllowUsersToManageMFA"
  }

  statement {
    condition {
      test      = "BoolIfExists"
      values    = [
        "false"
      ]
      variable  = "aws:MultiFactorAuthPresent"
    }
    effect = "Deny"
    not_actions = [
      "iam:*"
    ]
    resources = [
      "*"
    ]
    sid       = "BlockAccessToOtherFeaturesWithoutMFA"
  }
}

resource "aws_iam_user_policy" "user" {
  name    = "UserProfileSelfService"
  policy  = "${data.aws_iam_policy_document.user.json}"
  user    = "${aws_iam_user.user.name}"
}
