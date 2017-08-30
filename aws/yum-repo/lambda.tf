data "aws_iam_policy_document" "repo_watcher_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "lambda.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "repo_watcher" {
  name = "${var.name_prefix}-yum-repo-watcher"
  assume_role_policy = "${data.aws_iam_policy_document.repo_watcher_assume_role.json}"
}

resource "aws_cloudwatch_log_group" "repo_watcher_log_group" {
  name              = "/aws/lambda/${var.name_prefix}-yum-repo-watcher"
  retention_in_days = 7
}

data "aws_iam_policy_document" "repo_watcher" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.repo_watcher_log_group.arn}"
    ]
    sid       = "AllowLogCreation"
  }
  statement {
    actions   = [
      "codebuild:StartBuild"
    ]
    resources = [
      "${aws_codebuild_project.yum_repo.id}"
    ]
    sid       = "AllowStartBuild"
  }
}

resource "aws_iam_role_policy" "repo_watcher" {
  name    = "${var.name_prefix}-yum-repo-watcher"
  policy  = "${data.aws_iam_policy_document.repo_watcher.json}"
  role    = "${aws_iam_role.repo_watcher.id}"
}

data "aws_s3_bucket_object" "codebuild_runner" {
  bucket  = "lambdalambdalambda-repo"
  key     = "quinovas/codebuild-runner/codebuild-runner-0.1.1.zip"
}

resource "aws_lambda_function" "repo_watcher" {
  depends_on = ["aws_cloudwatch_log_group.repo_watcher_log_group"]
  environment {
    variables = {
      PROJECT_NAME = "${aws_codebuild_project.yum_repo.name}"
    }
  }
  function_name     = "${var.name_prefix}-yum-repo-watcher"
  handler           = "function.handler"
  role              = "${aws_iam_role.repo_watcher.arn}"
  runtime           = "python2.7"
  s3_bucket         = "${data.aws_s3_bucket_object.codebuild_runner.bucket}"
  s3_key            = "${data.aws_s3_bucket_object.codebuild_runner.key}"
  s3_object_version = "${data.aws_s3_bucket_object.codebuild_runner.version_id}"
}

resource "aws_lambda_permission" "repo_watcher" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.repo_watcher.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.yum_repo.arn}"
  statement_id  = "AllowExecutionFromS3Bucket"
}