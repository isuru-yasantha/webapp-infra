terraform {

   backend "s3" {
    bucket = "buildbucketms"
    key = "tfstate/terraform.tfstate"
    region = "us-east-1"
}

}

provider "aws" {
  region = var.region
}

/* Networking Module */

module "networking" {
  source = "./modules/networking"
  project              = var.project
  environment          = var.environment
  region               = var.region
  availability_zones   = var.availability_zones
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
}

/* IAM Module */

module "iam" {
  source = "./modules/iam"
  project              = var.project
  environment          = var.environment
  codebucket_arn       = var.codebucket_arn
  gitconnect_arn       = var.gitconnect_arn
}

/* Compute Module */

module "compute" {
  source = "./modules/compute"
  depends_on = [module.networking,module.iam,module.alb]
  project              = var.project
  environment          = var.environment
  region               = var.region
  imageurl             = var.imageurl
  ecstaskexecution_iam_role_arn = module.iam.ecstaskexecution_iam_role_arn
  service_sg_id        = module.networking.service_sg_id
  private_subnets_id   = module.networking.private_subnets_id
  target_group_arn     = module.alb.target_group_arn
}

/* LB Module */

module "alb" {
  source = "./modules/alb"
  depends_on = [module.networking]
  project              = var.project
  environment          = var.environment
  vpc_id               = module.networking.vpc_id
  public_subnets_id    = module.networking.public_subnets_id
  alb_sg_id            = module.networking.alb_sg_id
}

/* Pipeline Module */

module "pipeline" {
  source = "./modules/pipeline"
  depends_on = [module.compute]
  project              = var.project
  environment          = var.environment
  codebucket           = var.codebucket
  codebucket_arn       = var.codebucket_arn
  docker_user          = var.docker_user
  docker_password      = var.docker_password
  docker_registry_uri  = var.docker_registry_uri
  git_repo             = var.git_repo
  gitconnect_arn       = var.gitconnect_arn
  pipeline_role_arn    = module.iam.codepipeline_iam_role_arn
  codebuild_role_arn   = module.iam.codebuild_iam_role_arn
}
