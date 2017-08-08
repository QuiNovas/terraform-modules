data "aws_caller_identity" "current" {}

resource "aws_iam_user" "user" {
  name = "${var.name}"
  path = "${var.path}"
}

resource "aws_iam_user_ssh_key" "user" {
  count      = "${var.ssh_pub == "none" ? 0 : 1}"
  username   = "${aws_iam_user.user.name}"
  encoding   = "SSH"
  public_key = "${var.ssh_pub}"
}

data "aws_iam_policy_document" "user" {

  statement {
    actions   = [
      "iam:GetAccountPasswordPolicy",
      " iam:GetServiceLastAccessedDetails",
      "iam:ListAccountAliases",
      "iam:ListUsers"
    ]
    resources = [
      "*"
    ]
    sid       = "AllowAllUsersToListAccounts"
  }

  statement {
    actions   = [
      "iam:*AccessKey*",
      "iam:*LoginProfile",
      "iam:*ServiceSpecificCredential*",
      "iam:*SigningCertificate*",
      "iam:*SSHPublicKey*",
      "iam:ChangePassword",
      "iam:GenerateCredentialReport",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:GetAccountSummary",
      "iam:ListGroupsForUser",
      "iam:ListUserPolicies"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user${var.path}${var.name}"
    ]
    sid       = "AllowIndividualUserToManageTheirAccountInformation"
  }

  statement {
    actions   = [
      "iam:List*MFADevices"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user${var.path}${var.name}"
    ]
    sid       = "AllowIndividualUserToListTheirMFA"
  }

  statement {
    actions   = [
      "iam:*MFADevice"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/${var.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user${var.path}${var.name}"
    ]
    sid       = "AllowIndividualUserToManageThierMFA"
  }

  statement {
    condition {
      test      = "Null"
      values    = [
        "true"
      ]
      variable  = "aws:MultiFactorAuthPresent"
    }
    effect = "Deny"
    not_actions = [
      "iam:*LoginProfile",
      "iam:*MFADevice",
      "iam:ChangePassword",
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
      "iam:List*MFADevices",
      "iam:ListAccountAliases",
      "iam:ListUsers"
    ]
    resources   = [
      "*"
    ]
    sid         = "DenyEverythingExceptForBelowUnlessMFAd"
  }

  statement {
    condition {
      test        = "Null"
      values      = [
        "true"
      ]
      variable    = "aws:MultiFactorAuthPresent"
    }
    effect        = "Deny"
    actions       = [
      "iam:*LoginProfile",
      "iam:*MFADevice",
      "iam:ChangePassword",
      "iam:GetAccountSummary"
    ]
    not_resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/${var.name}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user${var.path}${var.name}"
    ]
    sid           = "DenyIamAccessToOtherAccountsUnlessMFAd"
  }
}

resource "aws_iam_user_policy" "user" {
  name    = "UserProfileSelfService"
  policy  = "${data.aws_iam_policy_document.user.json}"
  user    = "${aws_iam_user.user.name}"
}
