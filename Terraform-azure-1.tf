
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = "BB-praca-magisterka"
  location = "East Europe"
}


resource "azurerm_storage_account" "example" {
  name                     = "storageBB"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_virtual_machine" "example" {
  count                 = 5
  name                  = "myvmBB-${count.index}"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  vm_size               = "Standard_DS2_v2"
  network_interface_ids = [azurerm_network_interface.example[count.index].id]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name              = "osdisk-${count.index}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "myvm-${count.index}"
    admin_username = "***********"
    admin_password = "***********"
  }

  tags = {
    environment = "BB-Magisterka"
  }
}


resource "azurerm_network_interface" "example" {
  count               = 5
  name                = "myvm-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "myvm-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_subnet" "example" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_virtual_network" "example" {
  name                = "my-virtual-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}