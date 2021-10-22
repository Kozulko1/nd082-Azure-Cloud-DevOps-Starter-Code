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
}

resource "azurerm_virtual_network" "main" {
    name                = "${var.prefix}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    
    tags = var.common_tags
}

resource "azurerm_subnet" "main" {
    name = "${var.prefix}-subnet"
    resource_group_name  = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "main" {
    name = "${var.prefix}-nsg"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    security_rule{
        name = "subnet-access"
        description = "Allow access to VMs via subnet."
        priority = 101
        direction = "Outbound"
        access = "Allow"
        protocol = "*"
        source_address_prefix = "10.0.2.0/24"
        source_port_range = "*"
        destination_port_range = "*"
        destination_address_prefix = "VirtualNetwork"
    }

    security_rule{
        name = "internet-access"
        description = "Deny access to VMs via internet."
        priority = 100
        direction = "Inbound"
        access = "Deny"
        protocol = "*"
        source_address_prefix = "Internet"
        source_port_range = "*"
        destination_port_range = "*"
        destination_address_prefix = "VirtualNetwork"
    }

    tags = var.common_tags
}

resource "azurerm_network_interface" "main" {
    count = var.vm_size
    name                = "${var.prefix}-nic${count.index + 1}"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.main.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = var.common_tags
}

resource "azurerm_public_ip" "main"{
    name = "${var.prefix}-pip"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location
    allocation_method = "Static"

    tags = var.common_tags
}

resource "azurerm_lb" "main"{
    name = "${var.prefix}-lb"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location

    frontend_ip_configuration{
        name = "PublicIPAddress"
        public_ip_address_id = azurerm_public_ip.main.id
    }

    tags = var.common_tags
}

resource "azurerm_lb_backend_address_pool" "main"{
    loadbalancer_id = azurerm_lb.main.id
    name = "${var.prefix}-lb-bap"
}
/*
resource "azurerm_network_interface_backend_address_pool_association" "main"{
    count = var.vm_size
    network_interface_id = azurerm_network_interface.main[count.index].id
    ip_configuration_name = "internal"
    backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}
*/

resource "azurerm_availability_set" "main"{
    name = "${var.prefix}-avls"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location
    platform_fault_domain_count = var.vm_size
    platform_update_domain_count = var.vm_size

    tags = var.common_tags
}

data "azurerm_image" "packer"{
    name = "${var.packer_image_name}"
    resource_group_name = "${var.image_rg}"
}

resource "azurerm_managed_disk" "main"{
    count = var.vm_size
    name = "${var.prefix}-md${count.index + 1}"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    storage_account_type = "Standard_LRS"
    create_option = "Empty"
    disk_size_gb = "1"

    tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "main"{
    count = var.vm_size
    name = "${var.prefix}-vm${count.index + 1}"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location
    size = "Standard_B1s"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    disable_password_authentication = false
    availability_set_id = azurerm_availability_set.main.id
    network_interface_ids = [
        #element(azurerm_network_interface.main.*.id, count.index),
        azurerm_network_interface.main[count.index].id,
    ]

    os_disk{
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_id = data.azurerm_image.packer.id

    tags = var.common_tags
}