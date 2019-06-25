### env
variable "projectid" {}
variable "region" {}
variable "zone" {}

variable "prefix" {}

### network
variable "pub_sub_cidr" { }
variable "tcp_port_list" { default=[] }
variable "jumpbox_ip" {}

### gce
variable "machine_type" {}

### tags

