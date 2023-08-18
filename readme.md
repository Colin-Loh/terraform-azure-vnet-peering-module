# Azure Vnet Peering Module for Terraform

This Terraform module provides a simple interface for creating a VNet Peering relationship between two existing Azure Virtual Networks (VNets).

## Features

- Creates a peering relationship between two existing VNets.
- Allows for optional configuration of traffic forwarding and gateway transit settings.
- Utilise Terraform For Expressions, Local Variables and Conditions. 

<!-- START_TF_DOCS_CONTENT -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network_peering.peering](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.peering_back](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_peering"></a> [peering](#input\_peering) | values for peering | <pre>object({<br>    enabled_peering = bool<br>    vnet_1_name = string<br>    vnet_2_name = string<br>    allow_virtual_network_access = bool<br>    peer_front = object({<br>      name = string<br>      allow_forwarded_traffic_vnet1 = bool<br>      allow_gateway_transit_vnet1 = bool<br>      use_remote_gateways_vnet1 = bool<br>    })<br>    peer_back = object({<br>      name = string<br>      allow_forwarded_traffic_vnet2 = bool<br>      allow_gateway_transit_vnet2 = bool<br>      use_remote_gateways_vnet2 = bool<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | value for resource group name | `string` | n/a | yes |
| <a name="input_vnet_1_id"></a> [vnet\_1\_id](#input\_vnet\_1\_id) | value of the remote virtual network id | `string` | n/a | yes |
| <a name="input_vnet_2_id"></a> [vnet\_2\_id](#input\_vnet\_2\_id) | value of the remote virtual network id | `string` | n/a | yes |

## Usage
Basic usage of this module is as follows:

```hcl
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "this" {
    name = var.resource_group_name
    location = var.resource_group_location
}

module "network" {
    source = "git::https://github.com/Colin-Loh/terraform-azure-vnet-module.git"
    resource_group_name = azurerm_resource_group.this.name
    resource_group_location = azurerm_resource_group.this.location
    virtual_networks = var.virtual_networks
}

module "peering" {
    source = "git::https://github.com/Colin-Loh/terraform-azure-vnet-peering-module.git"
    peering = var.peering
    resource_group_name = azurerm_resource_group.this.name
    vnet_1_id = module.network.vnet_ids[var.peering.vnet_1_name]
    vnet_2_id = module.network.vnet_ids[var.peering.vnet_2_name]
}

```

## Example(s)

```hcl
resource "azurerm_virtual_network_peering" "peering" {
  count                        = var.peering.enabled_peering ? 1 : 0
  name                         = var.peering.peer_front.name
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.peering.vnet_1_name
  remote_virtual_network_id    = var.vnet_2_id
  allow_virtual_network_access = var.peering.allow_virtual_network_access
  allow_forwarded_traffic      = var.peering.peer_front.allow_forwarded_traffic_vnet1
  allow_gateway_transit        = var.peering.peer_front.allow_gateway_transit_vnet1
  use_remote_gateways          = var.peering.peer_front.use_remote_gateways_vnet1
}


resource "azurerm_virtual_network_peering" "peering_back" {
  count                        = var.peering.enabled_peering ? 1 : 0
  name                         = var.peering.peer_back.name
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.peering.vnet_2_name
  remote_virtual_network_id    = var.vnet_1_id
  allow_virtual_network_access = var.peering.allow_virtual_network_access
  allow_forwarded_traffic      = var.peering.peer_back.allow_forwarded_traffic_vnet2
  allow_gateway_transit        = var.peering.peer_back.allow_gateway_transit_vnet2
  use_remote_gateways          = var.peering.peer_back.use_remote_gateways_vnet2
}
```
<!-- END_TF_DOCS_CONTENT -->