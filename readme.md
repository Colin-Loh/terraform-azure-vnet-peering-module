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
    source = "https://github.com/Colin-Loh/terraform-azure-vnet-module.git"
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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|resource_group_name| (Required) Resource Group with vnets |String| n/a | yes |
|vnet_1_id| (Required) Virtual Network 1 ID |String| n/a | yes |
|vnet_2_id| (Optional) Virtual Network 2 ID |String| n/a | no |
| Peering | (Required) Peering that applies to the virtual network. <br> <br> Properties: <br> `Enabled_Peering` (Required) - Enable Vnet Peering <br> `vnet_1_name`(Required) - Virtual Network 1 Name <br> `vnet_2_name`(Required) - Virtual Network 2 Name <br> `allow_virtual_network_access`(Optional) Virtual Network Access Option <br> `peer_front_name`(Required) Virtual Network Peering Name <br> `peer_front_allow_forwarded_traffic_vnet1`(Optional) Virtual Network Allow Forwarded Traffic Option <br> `peer_front_allow_gateway_transit_vnet1`(Optional) Virtual Network Allow Gateway Transit Option <br> `peer_front_use_remote_gateways_vnet1`(Optional) Virtual Network Remote Gateway Option <br> | <pre>peering = list(object({<br>enabled_peering = bool<br>vnet_1_name = string <br>vnet_2_name = string<br>allow_virtual_network_access = bool <br> <br>peer_front = list(object({ <br> name = string <br> allow_forwarded_traffic_vnet1 = boolean <br> allow_gateway_transit_vnet1 = boolean <br> use_remote_gateways_vnet1 = boolean <br> })) <br> })) </pre> | `{}` | yes |




## Example

```
module "vnet_peering" {
  source = "git::https://github.com/Colin-Loh/terraform-azure-vnet-peering-module.git"
  resource_group_name = azurerm_resource_group.this.name
  vnet_1_id = module.network.vnet_ids[var.peering.vnet_1_name]
  vnet_2_id = module.network.vnet_ids[var.peering.vnet_2_name]
  
  peering = {
      enabled_peering = true
      vnet_1_name = "app-vnet"
      vnet_2_name = "db-vnet"
      allow_virtual_network_access = true

      peer_front = {
          name = "app-vnet-peering-db-vnet"
          allow_forwarded_traffic_vnet1 = false
          allow_gateway_transit_vnet1 = false
          use_remote_gateways_vnet1 = false
      }

      peer_back = {
          name = "db-vnet-peering-app-vnet"
          allow_forwarded_traffic_vnet2 = false
          allow_gateway_transit_vnet2 = false
          use_remote_gateways_vnet2 = false
      }
  }
}

```

## Outputs

N/A


