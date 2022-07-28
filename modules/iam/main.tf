/* IAM policy for ECS */

data "aws_iam_policy_document" "ecs_iam_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


/* Creating IAM Role for ECS */

resource "aws_iam_role" "ecstaskexecution_iam_role" {
  name               = "ecstaskexecutionIamRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_iam_policy.json

  tags = {
      project = "${var.project}"
      environment = "${var.environment}"
  }
}

/* Policy attachment for the IAM role */

resource "aws_iam_role_policy_attachment" "ecs_iam_role_attachment" {
  role       = "${aws_iam_role.ecstaskexecution_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  depends_on = [aws_iam_role.ecstaskexecution_iam_role]
}

resource "aws_iam_instance_profile" "ecstaskexecution_iam_role" {
  role = "${aws_iam_role.ecstaskexecution_iam_role.name}"
  depends_on = [aws_iam_role.ecstaskexecution_iam_role]
}

/*  Creating IAM Role for Code Pipeline */

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"
  depends_on = [aws_iam_role.ecstaskexecution_iam_role]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  depends_on = [aws_iam_role.ecstaskexecution_iam_role]
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${var.codebucket_arn}",
        "${var.codebucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${var.gitconnect_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codedeploy:*",
        "ecs:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "${aws_iam_role.ecstaskexecution_iam_role.arn}"
    }

  ]
}
EOF
}

/*  Creating IAM Role for CodeBuild */

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.codebucket_arn}",
        "${var.codebucket_arn}/*"
      ]
    }
  ]
}
EOF
}
