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

resource "azurerm_resource_group" "this" {
  name     = "tonfowler-rg"
  location = "West Europe"
}

