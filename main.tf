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



