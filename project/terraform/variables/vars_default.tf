variable "image_rg" {
  type        = string
  default     = "packer-image-rg"
  description = "Name of a resource group that has packer image resource."
}

variable "prefix" {
  type = string
  description = "The prefix used for all the resources on the project."
  default = "udacity-project"
}

variable "location" {
  type = string
  description = "The Azure region where all the resources on the project will be created."
  default = "westeurope"
}

variable "vm_size" {
  type        = number
  default     = 2
  description = "Number of Virtual Machines users are planning to have."
  validation{
    condition = var.vm_size > 0 && var.vm_size < 6
    error_message = "Number of Virtual Machines must be [1, 5]."
  }
}

variable "packer_image_name" {
  type        = string
  default     = "ubuntuProjectImage"
  description = "Name of the Packer image resource."
}

variable "admin_username" {
  type        = string
  default     = "Jane_Doe"
  description = "Username for VM admin."
}

variable "admin_password" {
  type        = string
  default     = "Secret0Word!"
  description = "Password for VM admin"
}

variable "common_tags" {
  type        = map
  default     = {
    "Project" = "Udacity"
    "Owner" = "Jane_Doe"
  }
  description = "Common tags used for tagging project resources."
}