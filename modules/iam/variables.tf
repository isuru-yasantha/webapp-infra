variable "project" {
  description = "The name of the project"
}

variable "environment" {
  description = "The deployment environment"
}

variable "codebucket_arn" {
  description = "ARN of the code bucket"
}

variable "gitconnect_arn" {
  description = "ARN of the git and aws pipeline connection"
  type = string
}
