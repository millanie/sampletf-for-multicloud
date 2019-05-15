# Env 
#profile = "default"
region = "ap-northeast-2"

# Tags
tag_stage = "dev"

# VPC
vpc_cidr_block = "10.200.0.0/16"
vpc_enable_dns_hostnames = true
pub_subnet_cidr_list = ["10.200.0.0/24", "10.200.1.0/24"]
prv_subnet_cidr_list = ["10.200.10.0/24", "10.200.11.0/24"]
az_list = ["ap-northeast-2c", "ap-northeast-2a"]

# EC2
ec2_type = "t2.micro"
# keyfile = "your created keyfile"
ec2_sg_list = []

ssh_port = "22"
http_port = "80"

# mybastion = "your ip/32"

# immediately              = false


