####### Env
provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
  
#  version = "~> 1.60"
}

####### VPC
# vpc 
resource "aws_vpc" "simpleservice" {
    cidr_block           = "${var.vpc_cidr_block}"
    enable_dns_hostnames = "${var.vpc_enable_dns_hostnames}"
}

# public subnet
resource "aws_subnet" "simpleservice-public" {
    count = "${length(var.pub_subnet_cidr_list)}"
    
    vpc_id = "${aws_vpc.simpleservice.id}"
    cidr_block = "${element(var.pub_subnet_cidr_list, count.index)}"
    availability_zone = "${element(var.az_list, count.index)}"
}

# private subnet
resource "aws_subnet" "simpleservice-private" {
    count = "${length(var.prv_subnet_cidr_list)}"
    
    vpc_id = "${aws_vpc.simpleservice.id}"
    cidr_block = "${element(var.prv_subnet_cidr_list, count.index)}"
    availability_zone = "${element(var.az_list, count.index)}"

}

# internet gateway
resource "aws_internet_gateway" "igw-simpleservice" {
    vpc_id = "${aws_vpc.simpleservice.id}"

}

# routing table
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.simpleservice.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw-simpleservice.id}"
    }

}

resource "aws_route_table_association" "rtb-simpleservice-public" {
    count = "${length(var.pub_subnet_cidr_list)}"

    route_table_id = "${aws_route_table.public.id}"
    subnet_id      = "${element(aws_subnet.simpleservice-public.*.id , count.index)}"
}

###### EC2
resource "aws_instance" "simpleservice" {
    count = 1

    availability_zone      = "${element(var.az_list, count.index)}"
    subnet_id              = "${element(aws_subnet.simpleservice-public.*.id, count.index)}"

    ami                    = "${data.aws_ami.amznlinux.id}"
    instance_type          = "${var.ec2_type}"
    key_name               = "${var.keyfile}"
    vpc_security_group_ids = ["${aws_security_group.simpleservice.id}"]

    root_block_device {
      volume_size          = 30 
    } 
    
}


# EIP
resource "aws_eip" "simpleservice" {
    count = 1

    vpc = true

    instance                  = "${element(aws_instance.simpleservice.*.id, count.index)}"
    associate_with_private_ip = "${element(aws_instance.simpleservice.*.private_ip, count.index)}"

}


# security group for ec2
resource "aws_security_group" "simpleservice" {
    name            = "simpleservice"

    vpc_id          = "${aws_vpc.simpleservice.id}"

    ## for SSH 
    ingress {
      from_port     = "${var.ssh_port}"
      to_port       = "${var.ssh_port}"
      protocol      = "tcp"
      cidr_blocks   = ["${var.mybastion}"]
    }

    ## for HealthCheck 
    ingress {
      from_port     = "${var.http_port}"
      to_port       = "${var.http_port}"
      protocol      = "tcp"
      cidr_blocks   = ["0.0.0.0/0"]
    }

    ## for outbound
    egress {
      from_port     = 0
      to_port       = 0
      protocol      = "-1"
      cidr_blocks   = ["0.0.0.0/0"]
    }

}

###### ALB

# attaching ec2 instances on ALB

