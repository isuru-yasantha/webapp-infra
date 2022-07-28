variable "project" {
  description = "The name of the project"
}

variable "environment" {
  description = "The deployment environment"
  default     = "dev"
}

variable "region" {
  description = "The AWS Region"
}

variable "availability_zones" {
  type        = list(any)
  description = "The names of the availability zones to use"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
}

variable "imageurl" {
  description = "container image"
  type        = string
}

variable "codebucket" {
  description = "code bucket for cicd"
}

variable "codebucket_arn" {
  description = "ARN of the code bucket"
  type        = string
}

variable "docker_user" {
  description = "Docker registry username"
  type        = string
}

variable "docker_password" {
  description = "Docker registry password"
  type        = string
}

variable "git_repo" {
  description = "Name of the git repo"
  type        = string
}

variable "docker_registry_uri" {
  description = "URI of the docker repo"
  type        = string
}

variable "gitconnect_arn" {
  description = "ARN of the git and aws pipeline connection"
  type = string
}
