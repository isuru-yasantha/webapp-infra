# Enea: Tech Challenge

## Solution design and deployment diagram

![Blank diagram](https://github.com/isuru-yasantha/assignment/blob/74d60ce06612cd299d665b6dae48d24100525b35/images/DeploymentDiagram.jpg)

## Tools and services 

- Terraform 
- GitHub
- AWS
- Docker
```
- AWS VPC
- AWS ECS
- AWS EC2 (ALB)
- AWS S3
- AWS IAM
- AWS RDS
- AWS CloudWatch
- AWS Codepipeline
- AWS Code Build
- AWS Code Deploy
```
 Above mentioned AWS services are selected to design and deploy this web application considering complexity to design, implement and operational overhead. Basic security features are implemented in this solution at this stage. However, there are things that we can improve for enhancing the security, performance and cost saving aspects which discuss under the improvement section.

 - AWS VPC -  Network segmentation and virtual network isolation. MZ and DMZ are implemented. 
 - AWS ECS - ECS with fargate is low cost, less complex solution to run containerized applications without putting much effort to - maintainance. Compute resources are provisioned and scaling based on resource utilisation which help to reduce the infrastructure cost. 
 - AWS EC2 (ALB) - ALB is used to front the public traffic to the application. 
 - AWS S3 - S3 is used to store and maintain Terraform state file.
 - AWS IAM - IAM role is used to grant access to AWS resources and AWS services in order to perform AWS API calls.
 - AWS SecretManager - Secret Manager is used to store and maintain database user password which is referred by the web application.
 - AWS RDS - RDS is used for HA enabled database instance (Multi AZ).
 - AWS Cloudwatch - Cloudwatch is used to handling monitoring metrics, logs and alarms. 
 - AWS Codepipeline - Code pipeline is used for setup a CI/CD pipeline using AWS Code Build and AWS Code Deploy along with Github

## How to run?

Please use below mentioned steps to deploy cloud infrasture for this solution once you met the prerequisites mentioned below.

### Prerequisites

1. Terraform. (Tested version for this solution - Terraform v1.0.11)
2. AWS CLI.
3. AWS IAM user(X) keys with AWS Administrator permissions.
3. AWS S3 bucket with below access policy to grant access to above mentioned IAM user(X) to put objects into the bucket. (Ex:S3bucket). However, This bucket and required policy will create using env-creation.sh script during the deployment process. Hence, manual creation is not required.
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			 "Principal": {
                "AWS": [
                    "arn:aws:iam::ACCOUNT_ID:user/x"
                ]},
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::BUCKET_NAME"
		},
		{
			"Effect": "Allow",
			 "Principal": {
                "AWS": [
                   "arn:aws:iam::ACCOUNT_ID:user/x"
                ]},
			"Action": [
				"s3:GetObject",
				"s3:PutObject",
				"s3:DeleteObject"
			],
			"Resource": "arn:aws:s3:::BUCKET_NAME/tfstate/terraform.tfstate"
		}
	]
}
```
4. Web Browser and OS. (Tested with Google Chrome and MAC OS)

### Steps to run

1. Clone the GitHub repo.
2. If you need to update the default values mentioned in the terraform.tfvars file, please update them in terraform.tfvars file.
```
project               = "samplewebapp"
environment           = "dev"
region                = "us-east-1"
availability_zones    = ["us-east-1a", "us-east-1b"]
vpc_cidr              = "10.92.0.0/16"
public_subnets_cidr   = ["10.92.0.0/24", "10.92.1.0/24"] //List of Public subnet cidr range
private_subnets_cidr  = ["10.92.10.0/24", "10.92.11.0/24"] //List of private subnet cidr range

imageurl              = "isuruwic/simple-webservice:v2"  // Base Docker Image for the web app
codebucket            = "tfstatebucket" // S3 Bucket for storing tfstate file
codebucket_arn        = "arn:aws:s3:::cicdbucket"  // S3 bucket for CI/CD pipeline related files
docker_user           = "xxxxxxxxx" // Username for docker.io registry
docker_password       = "xxxxxxxxx" // Password for docker.io registry
git_repo              = "isuru-yasantha/sample-web-app" // python web app git repo
docker_registry_uri   = "isuruwic/simple-webservice" // Docker registy URI
gitconnect_arn        = "GIT_CONNECTION_ARN" // ARN of the Github version 2 connection in AWS codepipeline
```
2. Provide executable permissions to the env-creation.sh 
```chmod +x env-creation.sh```

3. Run following command. 
```./env-creation.sh```

Please provide required details by the script and follow the steps mentioned in the script to run the environment build. You should provide AWS region, IAM user (has AWS administrator permissions) keys (Access key and Secret key), new S3 bucket name, AWS Account ID (number) and IAM username.

4. Please use env-deletion.sh to delete all the created resources. Please provide executable permissions to env-deletion.sh before run the script.
```chmod +x env-deletion.sh```
```./env-deletion.sh```

### Outputs

This Terraform script creates below resources, 

- 1 Private VPC
- 2 Public and 4 Private Subnets in two avaialability zones
- 2 NAT Gateways
- 1 Internet Gateway
- 2 Elastic IPs for the NAT Gateways
- Route Tables and Security Groups
- IAM Role
- ALB and Target group
- ECS cluster, Tasks and Service
- RDS instance
- Code pipeline with build and deploy stages

After succesful execution of the script, you will get an ALB DNS endpoint as an output below. Please use the output DNS entry to access the web appliaction using a web browser. 

```Ex: alb_endpoint = "lb_endpoint = "samplewebapp-dev-alb-186999999.us-east-1.elb.amazonaws.com""```

Sample CURLS commands with outputs

`` Health Check ``
``` curl http://samplewebapp-dev-alb-186999999.us-east-1.elb.amazonaws.com --> Healthy%```

`` Sample CURL command to add few numbers``
``` curl -d '{"sum of the numbers: " : [1, 100, 3,12]}' -H "Content-Type: application/json" -X POST http://samplewebapp-dev-alb-1869999999.us-east-1.elb.amazonaws.com/proc ---> "{\"sum of the numbers: \":{\"sum\":116}}"%```


## Improvements

 - Security enhancements 

    #### Data at rest:

    - AWS KMS key based encryption for AWS S3, AWS RDS and AWS Secret Manager

    #### Data at transit:

    - Enabling HTTPS listener at ALB and secure with TLS certificate using AWS ACM for the public traffic. 
    - Enabling HTTPS communication between app and RDS if app is supporting for establishing the HTTPS DB connection. 

    #### Network Security

    - Enabling AWS Shield for DDOS protection
    - Adding AWS Network ACL Rules for subnet traffic management
    - Enabling AWS GuardDuty for sending alerts based on suspecious behaviours

    #### Web application Security

    - Enable AWS WAF for ALB in order to protect from web based attacks
    - Enable traffic to ALB only from AWS CDN
    - Maintaning public domain name with Route53 and certificate via ACM for the domain

    #### Auditing

    - Enabling access logs, auth logs, general logs on AWS ALB,AWS RDS, AWS ECS, AWS S3, AWS Secret Manager if available
    - Enabling AWS Cloudtrails in the AWS region which AWS resources are provisioned
    - Enabling metric based and log based AWS Cloudwatch alarms for sending notifications via AWS SNS to stake holders

    ### Database

    - Creating separate DB user in the DB and grant access only particular DB for that user in order to connect to the DB from the application
    - Attaching seperate option group and parameter group for the RDS with finetuned values

- Performance enhancements  

    - Implementing a CDN to provide web application to the endusers
    - Implementing cloudwatch based alarms related to the scaling activities in ECS, error code based alarms for ALB, target group based alarms for unhealthy targets, RDS based alarms for critical metrics such as cpu,memory and storage (Attending issues in advance)
    - Implementing 3rd party health check or uptime monitor for the website
    - Setting up a seperate ECR for managing internal docker images

- Backups  

    - Enabling backups for AWS RDS, lifecycle policy for AWS S3 storage, log retention policy for AWS Cloudwatch logs
    - Implementing remote backend for TF state using Dynamo DB based solution
    - Replicatiing ECR regionally if required


- Cost savings

    - Analyzing the traffic patterns and resource utilisation metrics to come up with a better resource sizes. 

- Other 

   - Runing AWS trusted advisor to get recommendations related to cost,performance and security to achive best from those aspects
   - Implementing AWS recommendations after analyzing them closely according to the application requirements. 




### CI/CD Pipeline

Diagram describes the CI/CD process for this web application that can be implemented using AWS services.

![Blank diagram](https://github.com/isuru-yasantha/assignment/blob/0c27510c590b8e6d20106981c5d16e9729daf57a/images/cicdProcess.jpg)

### Monitoring, Logging and Alerts

#### Infrastructure Monitoring  

Enabling AWS Infrastructure monitoring is highly important. This can be achived using AWS native solution of AWS Cloudwatch and AWS SNS.

#### Web application Monitoring  

Application metrics can be monitored by publishing custom metrics to AWS Cloudwatch using custom developed scripts. If not, 3rd party monitoring tool can be integrated to achive this. 

#### Endpoint Monitoring  

Internal endpoints such as backends can be monitored using AWS cloudwatch. However, recommending to use 3rd party monitoring tool to monitor public endpoints and application health check flow without depending on one tool. 
