
terraform {
  backend "s3" {
    bucket = "<bucket name>"
    key = "demo/terraform.state"
    region = "ap-northeast-2"
  }
}

