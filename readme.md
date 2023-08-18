# Azure Vnet Peering Module for Terraform

This Terraform module provides a simple interface for creating a VNet Peering relationship between two existing Azure Virtual Networks (VNets).

## Features

- Creates a peering relationship between two existing VNets.
- Allows for optional configuration of traffic forwarding and gateway transit settings.
- Utilise Terraform For Expressions, Local Variables and Conditions. 

<!-- TF_DOCS_CONTENT -->
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
<!-- TF_DOCS_CONTENT -->
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
    source = "../"
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
<!-- TF_DOCS_CONTENT -->

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

<!-- TF_DOCS_CONTENT -->

