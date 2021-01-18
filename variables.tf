variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "udacity-azure"
}

variable "environment"{
  description = "The environment should be used for all resources in this example"
  default = "test"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "uk south" 
}

variable "username"{
  default = "username"
}

variable "password"{
  default= "Password11@"
}

variable "server_names"{
  type = list
  default = ["uat","int"]
}

variable "packerImageId"{
  default = "/subscriptions/XXXXXXXXXXXXXXX/resourceGroups/packer-rg/providers/Microsoft.Compute/images/udacityPackerImage"
}

variable "vm_count"{
  default = "2"
}
