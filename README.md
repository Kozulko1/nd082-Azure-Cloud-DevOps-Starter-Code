# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
First of all, you should clone this repository to your local machine.
Make sure you are logged in to your Azure account in the Azure CLI.
Open your terminal and move to root directory of the cloned repository.
Run $bash getting_started.sh
There you will specify if you would like to use default or user defined parameters.
If you chose default, you don't need to do anything else anymore.
If you didn't choose default, you will need to specify info for the resource group where your packer image would be deployed.
It may take a while to build your packer image.
Once your packer image is finished, you will need to specify info for your resources.


### Output
If you followed all the steps, you should have 2 new resource groups on your Azure portal.
One group will have a packer image resource and the other one will have a virtual network with running virtual machines.