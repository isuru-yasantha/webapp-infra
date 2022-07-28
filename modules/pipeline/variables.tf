variable "project" {
  description = "The name of the project"
}

variable "environment" {
  description = "The deployment environment"
}

variable "codebucket" {
  description = "The deployment cicd code bucket"
}

variable "pipeline_role_arn" {
  description = "ARN of the pipeline IAM role"
}

variable "codebuild_role_arn" {
  description = "ARN of the codebuild IAM role"
}

variable "codebucket_arn" {
  description = "ARN of the code bucket"
}

variable "docker_user" {
  description = "Docker registry username"
}

variable "docker_password" {
  description = "Docker registry password"
}

variable "git_repo" {
  description = "Name of the git repo"
}

variable "docker_registry_uri" {
  description = "URI of the docker repo"
}

variable "gitconnect_arn" {
  description = "ARN of the git and aws pipeline connection"
}

