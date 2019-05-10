### Azure Provider
provider "azurerm" {
}

### Resource Group
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${var.rgname}"
  location = "${var.location}"

  tags {
      environment = "${var.tag_stage}"
  }
}

### vnet 
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "${var.vnetname}"
  address_space       = ["${var.vnet_cidr_block}"]
  location            = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name = "${var.rgname}"

  tags {
      environment = "${var.tag_stage}"
  }
}

### subnet
resource "azurerm_subnet" "myterraformsubnet-public" {
  count = "${length(var.pub_subnet_cidr_list)}"

  name                 = "${var.pub_subnet_name}-${count.index}"
  resource_group_name  = "${var.rgname}"
  virtual_network_name = "${var.vnetname}"
  address_prefix       = "${element(var.pub_subnet_cidr_list, count.index)}"
}

### public ip
resource "azurerm_public_ip" "myterraformpublicip" {

  name                = "terraformdemoip"
  location            = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name = "${var.rgname}"
  allocation_method   = "Static"

  tags {
      environment = "${var.tag_stage}"
  }
}

### nsg
resource "azurerm_network_security_group" "myterraformnsg" {

  name = "terraformnsg"
  location            = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name = "${var.rgname}"
  
  security_rule {
      name                       = "${var.ssh_rulename}"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "${var.ssh_port}"
      source_address_prefix      = "${var.jumpbox_ip}"
      destination_address_prefix = "*"
  }

  tags {
      environment = "${var.tag_stage}"
  }
}

### network interface
resource "azurerm_network_interface" "myterraformnic" {
  name                = "myNIC"
  location            = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name       = "${var.rgname}"
  network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

  ip_configuration {
      name                          = "myNicConfiguration"
      subnet_id                     = "${azurerm_subnet.myterraformsubnet-public.id}"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
  }

  tags {
      environment = "${var.tag_stage}"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
  name                  = "${var.vm_name}"
  location              = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name   = "${var.rgname}"
  network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
  vm_size               = "${var.vm_size}"

  delete_os_disk_on_termination = true
 
  storage_os_disk {
      name              = "myOsDisk"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Premium_LRS"
  }

  # TODO:simplification
  storage_image_reference {
    publisher = "${var.publisher}"
    offer     = "${var.offer}"
    sku       = "${var.vmimagesku}"
    version   = "latest"
  }

  os_profile {
      computer_name  = "${var.vm_name}"
      admin_username = "${var.admin_user}"
      admin_password = "${var.password}"
  }

  os_profile_linux_config {
      disable_password_authentication = false 
      ### when true
      # ssh_keys {
      #     path     = "/home/${var.admin_user}/.ssh/authorized_keys"
      #     key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
      # }
  }

  boot_diagnostics {
      enabled = "true"
      storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
  }

  tags {
      environment = "${var.tag_stage}"
  }
}

# random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group_name = "${var.rgname}"
  }
  
  byte_length = 8
}

# storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                        = "diag${random_id.randomId.hex}"
  resource_group_name = "${var.rgname}"
  location              = "${azurerm_resource_group.myterraformgroup.location}"
  account_tier                = "Standard"
  account_replication_type    = "LRS"

  tags {
      environment = "${var.tag_stage}"
  }
}
