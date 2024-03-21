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
  name     = "tonyfox-gitops-rg"
  location = "North Europe"
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example_subnet" {
  for_each             = { for i in range(30) : i => format("10.0.%d.0/24", i) }
  name                 = "example-subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = [each.value]
}

resource "azurerm_virtual_network" "example_vnet98982" {
  name                = "example-vnet98982"
  address_space       = ["192.0.0.0/16"]
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example_subnet2" {
  for_each             = { for i in range(40) : i => format("192.0.%d.0/24", i) }
  name                 = "example-subnet2-${each.key}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example_vnet98982.name
  address_prefixes     = [each.value]
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = var.rg_location
}

# This is the module call
module "nsg" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  enable_telemetry    = var.enable_telemetry
  resource_group_name = azurerm_resource_group.this.name
  name                = module.naming.network_security_group.name_unique
  location            = var.location
  nsgrules            = var.rules
}


