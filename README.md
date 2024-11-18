# Lake Formation Demo

## Overview

This project demonstrates how to:
- Build a data lake with data stored in S3
- Create an ETL job that copy data between data lakes


## Requirements

- Terraform v1.9
- An S3 bucket for storing Terraform state
- A DynamoDB table used for Terraform state locking


## Prepare

Create a `backend.tfvars` file that contains configuration for Terraform S3 backend:
```hcl filename="params.tfvars"
region               = ""
workspace_key_prefix = ""
bucket               = ""
key                  = ""
dynamodb_table       = ""
```

Create a `params.tfvars` file that contain required input parameters (see [`variables.tf`](./variables.tf)):
```hcl filename="params.tfvars"
region          = ""
owner           = ""
project         = ""
artifact_bucket = ""
```

Init the project:
```shell
terraform init -backend-config=backend.tfvars -reconfigure
terraform workspace new dev
terraform workspace select dev
```


## Create AWS resources

```shell
terraform apply -var-file="params.tfvars" --auto-approve
```


## Clean up

```sh
terraform destroy -var-file="params.tfvars" --auto-approve
terraform workspace select default
terraform workspace delete dev
```
