## Env
variable "profile" { description = "profile information to build this terraform architecture" }
variable "region" { description = "aws region to build this terraform architecture" }
variable "az_list" { default = [] }

## VPC
variable "vpc_cidr_block" { description = "CIDR Block for VPC" }
variable "vpc_enable_dns_hostnames" { description = "Boolean variable for enabling dns hostnames" }
variable "pub_subnet_cidr_list" { default = [] }
variable "prv_subnet_cidr_list" { default = [] }

## EC2
variable "ec2_type" { description = "instance type" }
variable "keyfile" { description = "keypair name for ec2 which you prepares" }
variable "ec2_sg_list" { default = [] }
variable "ssh_port" { description = "port information for SSH" }
variable "http_port" { description = "port information for HTTP" }
variable "mybastion" { description = "IP address for bastion to make ingress" }

## Tag
variable "tag_stage" { description = "mandatory tag for all aws resources" }

