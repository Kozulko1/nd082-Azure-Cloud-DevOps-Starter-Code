terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=2.46.0"
        }
    }
}

provider "azurerm"{
    features {}
}

resource "azurerm_resource_group" "main" {
    name     = "${var.prefix}-rg"
    location = var.location
    tags{
        project = "Udacity"
        owner = "Kozulko"
    }
}

resource "azurerm_virtual_network" "main" {
    name                = "${var.prefix}-vnet"
    address_space       = ["10.0.0.0/24"]
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    tags{
        project = "Udacity"
        owner = "Kozulko"
        network = "Project Network"
    }
}

resource "azurerm_subnet" "internal" {
    name = "internal"
    resource_group_name  = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["10.0.2.0/24"]
    tags{
        project = "Udacity"
        owner = "Kozulko"
        subnet = "Default Subnet"
    }
}

resource "azurerm_network_security_group" "main" {
    name = "${var.prefix}-nsg"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    tags{
        project = "Udacity"
        owner = "Kozulko"
        type = "Access Rules"
    }

    security_rule{
        name = "subnet-access"
        description = "Allow access to VMs via subnet."
        priority = 101
        direction = "Outbound"
        access = "Allow"
        protocol = "*"
        source_address_prefix = ["10.0.2.0/24"]
        source_port_range = "*"
        destination_port_range = "*"
        destination_address_prefix = "VirtualNetwork"
    }

    security_rule{
        name = "internet-access"
        description = "Deny access to VMs via internet."
        priority = 101
        direction = "Inbound"
        access = "Deny"
        protocol = "*"
        source_address_prefix = "Internet"
        source_port_range = "*"
        destination_port_range = "*"
        destination_address_prefix = "VirtualNetwork"
    }
}

resource "azurerm_network_interface" "main" {
    name                = "${var.prefix}-nic"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.internal.id
        private_ip_address_allocation = "Dynamic"
    }

    tags{
        project = "Udacity"
        owner = "Kozulko"
        type = "NIC"
    }
}

resource "azurerm_public_ip" "main"{
    name = "${var.prefix}-pip"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location
    allocation_method = "Static"

    tags{
        project = "Udacity"
        owner = "Kozulko"
        type = "public IP"
    }
}

resource "azurerm_lb" "main"{
    name = "${var.prefix}-lb"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location

    frontend_ip_configuration{
        name = "PublicIPAddress"
        public_ip_address_id = azurerm_public_ip.main.id
    }

    tags{
        project = "Udacity"
        owner = "Kozulko"
        type = "Load Balancer"
    }
}

resource "azurerm_lb_backend_address_pool" "main"{
    loadbalancer_id = azurerm_lb.main.id
    name = "${var.prefix}-lb-bap"

    tags{
        project = "Udacity"
        owner = "Kozulko"
        type = "LB Backend Address Pool"
    }
}

resource "azurerm_network_interface_backend_address_pool_association" "main"{
    network_interface_id = azurerm_network_interface.main.id
    ip_configuration_name = "test-configuration"
    backend_address_pool_id = azurerm_lb_backend_address_pool.main.id

    tags{
        project = "Udacity"
        owner = "Kozulko"
        type = "NIC BAPA"
    }
}

resource "azurerm_availability_set" "main"{
    name = "${var.prefix}-avls"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location

    tags{
        project = "Udacity"
        owner = "Kozulko"
        type = "VM Availability Set"
    }
}