data "aws_iam_policy_document" "yum_repo_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "codebuild.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "yum_repo" {
  assume_role_policy  = "${data.aws_iam_policy_document.yum_repo_assume_role.json}"
  name                = "${var.name_prefix}-yum-repo-codebuild"
}

data "aws_iam_policy_document" "yum_repo_codebuild" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
    sid = "AllowCodeBuildToWriteLogs"
  }
  statement {
    actions = [
      "s3:DeleteObject*",
      "s3:GetObject*",
      "s3:PutObject*"
    ]
    resources = [
      "${aws_s3_bucket.yum_repo.arn}",
      "${aws_s3_bucket.yum_repo.arn}/*"
    ]
    sid = "AllowReadingAndWritingToYumRepoBucket"
  }
}

resource "aws_iam_role_policy" "yum_repo" {
  name    = "YumRepoBuild"
  policy  = "${data.aws_iam_policy_document.yum_repo_codebuild.json}"
  role    = "${aws_iam_role.yum_repo.id}"
}

resource "aws_codebuild_project" "yum_repo" {
  artifacts {
    type = "NO_ARTIFACTS"
  }
  description    = "Creates a Yum Repo(s) is the specified S3 bucket at the specified locations"
  environment {
    compute_type  = "BUILD_GENERAL1_SMALL"
    environment_variable {
      name  = "YUM_REPO_BUCKET"
      value = "${aws_s3_bucket.yum_repo.bucket}"
    }
    environment_variable {
      name  = "REPO_LOCATIONS"
      value = "${join(" ", var.repo_locations)}"
    }
    image         = "aws/codebuild/eb-python-3.4-amazonlinux-64:2.3.2"
    type          = "LINUX_CONTAINER"
  }
  name          = "${var.name_prefix}-yum-repo"
  service_role  = "${aws_iam_role.yum_repo.arn}"
  source {
    type      = "GITHUB"
    location  = "https://github.com/QuiNovas/create-s3-yum-repo"
  }
}