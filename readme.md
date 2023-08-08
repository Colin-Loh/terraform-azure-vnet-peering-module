# Azure Vnet Peering Module for Terraform

This Terraform module provides a simple interface for creating a VNet Peering relationship between two existing Azure Virtual Networks (VNets).

## Features

- Creates a peering relationship between two existing VNets.
- Allows for optional configuration of traffic forwarding and gateway transit settings.
- Utilise Terraform For Expressions, Local Variables and Conditions. 

## Usage

Include this repository as a module in your existing terraform code:

```
module "network" {
    source = "./modules/network"
    resource_group_name = azurerm_resource_group.this.name
    resource_group_location = azurerm_resource_group.this.location
    virtual_networks = var.virtual_networks
}


module "vnet_peering" {
  source = "git::https://github.com/Colin-Loh/terraform-azure-vnet-peering-module.git"

  peering = var.peering
  resource_group_name = azurerm_resource_group.this.name
  vnet_1_id = module.network.vnet_ids[var.peering.vnet_1_name]
  vnet_2_id = module.network.vnet_ids[var.peering.vnet_2_name]
}



```

## Inputs

Name | Description | Type | Default | Required


## Outputs


