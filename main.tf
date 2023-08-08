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