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
  location = "West Europe"
}

resource "azurerm_network_security_group" "example" {
  name                = "gitopsexample-security-group"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_network" "example" {
  name                = "gitopsexample-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.example.id
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
    security_group = azurerm_network_security_group.example.id
  }
  subnet {
    name           = "subnet4"
    address_prefix = "10.0.4.0/24"
    security_group = azurerm_network_security_group.example.id
  }
  tags = {
    environment = "Production"
  }
}
