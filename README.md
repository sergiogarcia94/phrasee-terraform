## Phrasee terraform challenge
Built using Terraform `v1.4.0`

### How to run it

#### v1
```
// This will the VPC and all the networking resources
$ AWS_PROFILE=phrasee_terraform make plan

// To use an existing VPC
$ AWS_PROFILE=phrasee_terraform make plan external_vpc_id=vpc-XXXXXX external_public_subnet_id=subnet-XXXXXX

// This will the VPC and all the networking resources
$ AWS_PROFILE=phrasee_terraform make apply

// To use an existing VPC
$ AWS_PROFILE=phrasee_terraform make apply external_vpc_id=vpc-XXXXXX external_public_subnet_id=subnet-XXXXXX
```
To configure the deployment add the required values to v1/terraform/config.tfvars

#### v2
This version will using Hashicorp Packer to build the AMI, to avoid changes in running EC2 instances


### Next steps
- If the use case is to serve static html files from s3 and you are not using nginx features use cloudfront instead
- If you are using nginx features that do not exist in NLB or ALB move the nginx container to ECS
- If the use of EC2 instances is justified at least create an Auto Scaling groups for more resiliency

- The service/app creating the index.html should be the one uploading the file to S3