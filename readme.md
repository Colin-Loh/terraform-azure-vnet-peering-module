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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.71.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_peering"></a> [peering](#input\_peering) | (Required) Configuration for virtual network peering.<br>    Properties:<br>      `allow_virtual_network_access` (Required)   - flag to allow virtual network access<br>      `virtual_networks` (Required)               - list of virtual networks<br>        `name` (Required)                      - virtual network name<br>        `allow_forwarded_traffic` (Required)   - allow forwarded traffic flag<br>        `allow_gateway_transit` (Required)     - allow gateway transit flag<br>        `use_remote_gateways` (Required)       - use remote gateways flag | <pre>object({<br>    allow_virtual_network_access = bool<br>    virtual_networks = list(object({<br>      name                    = string<br>      allow_forwarded_traffic = bool<br>      allow_gateway_transit   = bool<br>      use_remote_gateways     = bool<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of the resource group where the virtual networks reside. | `string` | n/a | yes |

## Usage
Basic usage of this module is as follows:

```hcl
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "this" {
  name = "rg-terraform-vnet-peer"
}

module "peering" {
  source = "../"

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
```

## Example(s)

```hcl
data "azurerm_client_config" "this" {}

resource "azurerm_virtual_network_peering" "this" {
  for_each = {
    for id, network in var.peering.virtual_networks :
    network.name => {
      network = var.peering.virtual_networks[id]
      peer    = id == 0 ? var.peering.virtual_networks[1] : var.peering.virtual_networks[0]
    }
  }

  name = format(
    "%s-peering-%s",
    each.value.network.name,
    each.value.peer.name
  )
  virtual_network_name = each.value.network.name
  resource_group_name  = var.resource_group_name
  remote_virtual_network_id = format(
    "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s",
    data.azurerm_client_config.this.subscription_id,
    var.resource_group_name,
    each.value.peer.name
  )
  allow_virtual_network_access = var.peering.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.network.allow_forwarded_traffic
  allow_gateway_transit        = each.value.network.allow_gateway_transit
  use_remote_gateways          = each.value.network.use_remote_gateways
}
```
<!-- END_TF_DOCS_CONTENT -->