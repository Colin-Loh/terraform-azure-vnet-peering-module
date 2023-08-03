resource "azurerm_resource_group" "this" {
    name = var.resource_group_name
    location = var.resource_group_location
}

module "network" {
    source = "./modules/network"
    resource_group_name = azurerm_resource_group.this.name
    resource_group_location = azurerm_resource_group.this.location
    virtual_networks = var.virtual_networks
}

module "peering" {
    source = "./modules/peering"
    peering = var.peering
    resource_group_name = azurerm_resource_group.this.name
    vnet_1_id = module.network.vnet_ids[var.peering.vnet_1_name]
    vnet_2_id = module.network.vnet_ids[var.peering.vnet_2_name]
}
