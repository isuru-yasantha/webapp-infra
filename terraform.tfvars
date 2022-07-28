project               = "samplewebapp"
environment           = "dev"
region                = "us-east-1"
availability_zones    = ["us-east-1a", "us-east-1b"]
vpc_cidr              = "10.92.0.0/16"
public_subnets_cidr   = ["10.92.0.0/24", "10.92.1.0/24"]    //List of Public subnet cidr range
private_subnets_cidr  = ["10.92.10.0/24", "10.92.11.0/24"]  //List of private subnet cidr range

imageurl              = "isuruwic/simple-webservice:v2"     // Base Docker Image for the web app
codebucket            = "tfstatebucket"                     // S3 Bucket for storing tfstate file
codebucket_arn        = "arn:aws:s3:::cicdbucket"           // S3 bucket for CI/CD pipeline related files
docker_user           = "xxxxxxxxx"                         // Username for docker.io registry
docker_password       = "xxxxxxxxx"                         // Password for docker.io registry
git_repo              = "isuru-yasantha/sample-web-app"     // python web app git repo
docker_registry_uri   = "isuruwic/simple-webservice"        // Docker registy URI
gitconnect_arn        = "GIT_CONNECTION_ARN"                // ARN of the Github version 2 connection in AWS codepipeline