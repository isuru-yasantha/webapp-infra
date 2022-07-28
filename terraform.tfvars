project               = "samplewebapp"
environment           = "dev"
region                = "us-east-1"
availability_zones    = ["us-east-1a", "us-east-1b"]
vpc_cidr              = "10.92.0.0/16"
public_subnets_cidr   = ["10.92.0.0/24", "10.92.1.0/24"] //List of Public subnet cidr range
private_subnets_cidr  = ["10.92.10.0/24", "10.92.11.0/24"] //List of private subnet cidr range

imageurl              = "isuruwic/simple-webservice:v2"
codebucket            = "buildbucketms"
codebucket_arn        = "arn:aws:s3:::buildbucketms"
docker_user           = "isuruwic"
docker_password       = "fXi5%97s.W9Td#f"
git_repo              = "isuru-yasantha/sample-web-app"
docker_registry_uri   = "isuruwic/simple-webservice"
gitconnect_arn        = "arn:aws:codestar-connections:us-east-1:212683070493:connection/de388fc7-5f5d-4d69-851c-e4afe7e2ffff"


