data "aws_availability_zones" "all" {}

data "aws_ami" "amznlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"] # Canonical
}

#    ami                    = "${data.aws_ami.amznlinux.id}"

