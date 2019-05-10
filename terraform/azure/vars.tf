# variable "prefix" { default = "" }

### resource group
variable "rgname" {}
variable "location" {}

### network 
variable "vnetname" {}
variable "vnet_cidr_block" {}
variable "pub_subnet_name" { }
variable "pub_subnet_cidr_list" { default = [] }

variable "ssh_rulename" {default = "ssh"}
variable "ssh_port" {}
variable "jumpbox_ip" {}

### vm
variable "vm_name" {}
variable "vm_size" {}
variable "publisher" {}
variable "offer" {}
variable "vmimagesku" {}
variable "admin_user" { default = "azuser"}
variable "password" {}

### tags
variable "tag_stage" {}

