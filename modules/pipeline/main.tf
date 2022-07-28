/* Creating Code Build Project */

resource "aws_codebuild_project" "sampleWebAppBuild" {
  name          = "${var.project}-${var.environment}-Build"
  description   = "Building project for sample app"
  build_timeout = "60"
  service_role  = "${var.codebuild_role_arn}"

  artifacts {
    type = "CODEPIPELINE"
    name = "samplewebapp"
    packaging = "NONE"
  }

  cache {
    type     = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

    environment_variable {
      name  = "DOCKER_USER"
      value = "${var.docker_user}"
    }

    environment_variable {
      name  = "DOCKER_PASSWORD"
      value = "${var.docker_password}"
    }

      environment_variable {
      name  = "REPOSITORY_URI"
      value = "${var.docker_registry_uri}"
    }

      environment_variable {
      name  = "CONTAINER_NAME"
      value = "${var.project}-${var.environment}-container"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "cb-log-group"
      stream_name = "webapp-log-stream"
    }

    s3_logs {
      status   = "DISABLED"
    }
  }

  source {
    type            = "CODEPIPELINE"
  }

  tags = {
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

/* Creating Code Pipeline */

resource "aws_codepipeline" "codepipeline" {

  depends_on = [aws_codebuild_project.sampleWebAppBuild]
  name     = "${var.project}-${var.environment}-pipeline"
  role_arn = "${var.pipeline_role_arn}"

  artifact_store {
    location = "${var.codebucket}"
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn    = "${var.gitconnect_arn}"
        FullRepositoryId = "${var.git_repo}"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "${var.project}-${var.environment}-Build"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["BuildArtifact"]
      version         = "1"

      configuration = {
       ClusterName = "${var.project}-${var.environment}-ecs-cluster"
       ServiceName = "${var.project}-${var.environment}-ecs-service"
      }
    }
  }
}
