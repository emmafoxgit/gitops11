terraform {
  cloud {
    organization = "emmafoxorg"

    workspaces {
      name = "gitops11"
    }
  }

}
  


provider "azurerm" {
  features {}
  }



resource "azurerm_resource_group" "example" {
  name     = "tony-gitops-rg"
  location = "North Europe"
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example_subnet" {
  for_each             = { for i in range(10) : i => format("10.0.%d.0/24", i) }
  name                 = "example-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = [each.value]
}

resource "azurerm_virtual_network" "example_vnet2" {
  name                = "example-vnet2"
  address_space       = ["10.1.1.0/16"]
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example_subnet2" {
  for_each             = { for i in range(10) : i => format("10.1.%d.0/24", i) }
  name                 = "example-subnet2-${each.key}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = [each.value]
}
