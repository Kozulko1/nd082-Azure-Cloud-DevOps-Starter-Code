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
1. You should clone this repository to your local machine.
2. Make sure you are logged in to your Azure account in the Azure CLI.
3. Open your terminal and move to root directory of the cloned repository.
4. Run $bash getting_started.sh
5. There you will specify if you would like to use default or user defined parameters.
6. If you chose default, you don't need to do anything else anymore.
7. If you didn't choose default, you will need to specify info for the resource group where your packer image would be deployed.
8. It may take a while to build your packer image.
9. Once your packer image is finished, you will need to specify info for your resources.


### Output
If you followed all the steps, you should have 2 new resource groups on your Azure portal.
One group will have a packer image resource and the other one will have a virtual network with running virtual machines.