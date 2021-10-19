variable "prefix" {
  description = "The prefix used for all the resources on the project."
}

variable "location" {
  description = "The Azure region where all the resources on the project will be created."
  default = "Switzerland North"
}
