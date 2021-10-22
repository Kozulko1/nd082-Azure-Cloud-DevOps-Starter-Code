#!/bin/bash
cd project
cd terraform
terraform init
cd variables/
mv vars_default.tf ..
cd ..
terraform plan -out solution.plan
terraform apply "solution.plan"
mv vars_default.tf variables
cd ..
cd ..