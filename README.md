# sampletf-for-multicloud

### update plan
* priority for azure    
  - [ ] upgrade code for terraform 0.12
  - [ ] apply key vault

### Installation
The available downloads for the latest version of Terraform are [here](https://www.terraform.io/downloads.html). 

* Sample on CentOS
> $ wget {package url fit on your os platform}  
> $ unzip terraform_{version}_linux_amd64.zip  
> $ sudo mv terraform /usr/local/bin  

* Test
> $ terraform

### Basic commands
* run on each working directory for initializing and bringing it up to date with changes in the configurations.
  > $ terraform init

* simulate the terraform scripts before applying
  > $ terraform plan

* apply the terraform scripts
  > $ terraform apply

* destroy all the resources created by the terraform scripts
  > $ terraform destroy


