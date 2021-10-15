#!/bin/bash
echo -e "Type a name for your resource group: "
read rg_name
echo -e "Type the location of your resource group: "
read rg_location
az group create \
    --name $rg_name \
    --location $rg_location