# prefix = 
#
### resource group
rgname   = "demo"
location = "eastus" 

### network 
vnetname = "demo"
vnet_cidr_block = "10.0.0.0/16"
pub_subnet_name = "public"
pub_subnet_cidr_list = ["10.0.1.0/24"] 

ssh_port = 22
# jumpbox_ip 

### vm
vm_name = "demo"
vm_size = "Standard_DS2_v2"
publisher = "OpenLogic"
offer = "CentOS"
vmimagesku = "7.5"
admin_user = "azuser"

### tags
tag_stage = "demo"

