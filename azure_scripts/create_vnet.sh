#!/bin/bash
echo -e "Name your virtual network: "
read vnet_name
echo -e "Select resource group for your virtual network: "
read rg_name
echo -e "Name a subnet for your virtual network: "
read subnet_name
az network vnet create \
    --name $vnet_name \
    --resource-group $rg_name \
    --subnet-name $subnet_name \