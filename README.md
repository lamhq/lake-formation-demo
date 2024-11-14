# Lake Formation Demo

## Overview

A project that demonstate:
- Build a data lake with S3 data source
- Create an ETL job that load data to data lake


## Frequently Used Commands

Init project
```shell
terraform init -backend-config=backend.tfvars -reconfigure
terraform workspace new dev
terraform workspace select dev
```

Preview changes:
```shell
terraform plan -var-file="params.tfvars"
```

Deploy:
```shell
terraform apply -var-file="params.tfvars" --auto-approve
```

Clean up:
```sh
terraform destroy -var-file="params.tfvars" --auto-approve
terraform workspace select default
terraform workspace delete dev
```


## Todo

### Build a data lake

- [ ] allow querying table from athena without granting permission to user

### Create an ETL job
- [ ] apply least-privileges to `AWSGlueServiceRole-lakef-demo-glue-job`
- [ ] incremental ingest (job bookmark?)

Administators:
- [ ] grant permissions to data lake administrator to query data
