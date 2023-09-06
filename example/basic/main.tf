provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "this" {
  name = "rg-terraform-vnet-peer"
}

module "peering" {
  source = "../.."

  resource_group_name = data.azurerm_resource_group.this.name

  peering = {
    allow_virtual_network_access = true
    virtual_networks = [
      {
        name                    = "db-vnet"
        allow_forwarded_traffic = false
        allow_gateway_transit   = false
        use_remote_gateways     = false
      },
      {
        name                    = "app-vnet"
        allow_forwarded_traffic = false
        allow_gateway_transit   = false
        use_remote_gateways     = false
      }
    ]
  }
}
