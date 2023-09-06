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
