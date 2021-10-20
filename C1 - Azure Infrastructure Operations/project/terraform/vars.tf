variable "prefix" {
  type = string
  description = "The prefix used for all the resources on the project."
  default = "udacity-project"
}

variable "location" {
  description = "The Azure region where all the resources on the project will be created."
  default = "switzerlandnorth"
}

variable "vm_size" {
  type        = number
  default     = 1
  description = "Number of Virtual Machines users are planning to have."
  validation{
    condition = var.vm_size > 0
    error_message = "Number of Virtual Machines must be greater than 0."
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