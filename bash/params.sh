#!/bin/bash
echo -e "Choose a name for your image resource group: "
read rg_name_image
echo -e "Choose the location of your resource group: "
read rg_location
az group create \
    --name $rg_name_image \
    --location $rg_location

IFS= read -r -p "Type image owner name (no spaces allowed): " owner_name

printf "{\n\t\"rg_name\": \"%s\",
    \"owner\": \"%s\",
    \"location\": \"%s\"\n}" $rg_name_image $owner_name $rg_location \
    > project/packer/vars.json

printf "This may take a while, don't turn off your computer.\n"

packer build \
    -var-file=project/packer/vars.json \
    project/packer/server.json

cd project
cd terraform
terraform init
cd variables/
mv vars_params.tf ..
cd ..
terraform plan -out solution.plan
terraform apply "solution.plan"
mv vars_params.tf variables
cd ..
cd ..