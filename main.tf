terraform {

   backend "s3" {
    bucket = "samplebuildbucket"
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

