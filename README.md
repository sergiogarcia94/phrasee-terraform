## Phrasee terraform challenge
Built using Terraform `v1.4.0`

### How to run it

#### v1
```
$ make plan

$ make apply
```

#### v2
This version is using Hashicorp Packer to build the AMI, to avoid changes in running EC2 instances
```
$ make plan

$ make apply
```

### Next steps
- If the use case is to serve static html files from s3 and you are not using nginx features use cloudfront instead
- If you are using nginx features that do not exist in NLB or ALB move the nginx container to ECS
- If the use of EC2 instances is justified at least create an Auto Scaling groups for more resiliency

- The service/app creating the index.html should be the one uploading the file to S3