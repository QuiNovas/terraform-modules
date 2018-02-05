resource "aws_ecr_repository" "repo" {
  name = "${var.name}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "repo" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "${var.cross_account_users}"
      ]
      type = "AWS"
    }
    sid     = "AllowCrossAccountAccess"
  }
}

resource "aws_ecr_repository_policy" "repo" {
  policy      = "${data.aws_iam_policy_document.repo.json}"
  repository  = "${aws_ecr_repository.repo.name}"
}

resource "aws_ecr_lifecycle_policy" "repo" {
  policy      = <<POLICY
{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "description": "Keep only one untagged image, expire all others",
      "rulePriority": 1,
      "selection": {
        "countNumber": 1,
        "countType": "imageCountMoreThan",
        "tagStatus": "untagged"
      }
    },
    {
      "action": {
        "type": "expire"
      },
      "description": "Keep 20 tagged images, expire all others",
      "rulePriority": 3,
      "selection": {
        "countNumber": 20,
        "countType": "imageCountMoreThan",
        "tagPrefixList": [
          "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
          "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r",
          "s", "t", "u", "v", "w", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
        ],
        "tagStatus": "tagged"
      }
    }
  ]
}
POLICY
  repository  = "${aws_ecr_repository.repo.name}"
}
