locals {
  subnets_flatlist = flatten([for key, val in var.virtual_networks : [
    for subnet in val.subnets : [
      for nic in subnet.network_interfaces : {
        vnet_name              = val.name
        subnet_name            = subnet.subnet_name
        subnet_address         = subnet.subnet_address
        network_interface_name = nic.network_interface_name
        ip_configuration_name  = nic.ip_configuration_name
      }
    ]
    ]
  ])

  subnets = { for subnet in local.subnets_flatlist : subnet.subnet_name => subnet }
}

resource "azurerm_virtual_network" "this" {
  for_each = var.virtual_networks

  name                = each.value.name
  address_space       = each.value.address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = each.value.subnet_name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_name].name
  address_prefixes     = each.value.subnet_address
}

data "azurerm_subnet" "subnet" {
  for_each = local.subnets

  name                 = each.key
  virtual_network_name = each.value.vnet_name
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_subnet.this]
}

resource "azurerm_network_interface" "this" {
  for_each = local.subnets

  name                = each.value.network_interface_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuration_name
    subnet_id                     = data.azurerm_subnet.subnet[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
  }
}
