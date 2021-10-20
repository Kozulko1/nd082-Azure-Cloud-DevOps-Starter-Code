variable "prefix" {
  description = "The prefix used for all the resources on the project."
  default = "udacity-project"
}

variable "location" {
  description = "The Azure region where all the resources on the project will be created."
  default = "Switzerland North"
}

variable "vm_size" {
  type        = number
  default     = 1
  description = "Number of Virtual Machines users are planning to have."
}
