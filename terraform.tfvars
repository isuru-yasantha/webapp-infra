project               = "samplewebapp"
environment           = "dev"
region                = "us-east-1"
availability_zones    = ["us-east-1a", "us-east-1b"]
vpc_cidr              = "10.92.0.0/16"
public_subnets_cidr   = ["10.92.0.0/24", "10.92.1.0/24"] //List of Public subnet cidr range
private_subnets_cidr  = ["10.92.10.0/24", "10.92.11.0/24"] //List of private subnet cidr range
