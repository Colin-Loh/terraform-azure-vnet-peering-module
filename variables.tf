variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "virtual_networks" {
  type = map(object({
    name = string
    address_space = list(string)

    subnets = list(object({
      subnet_name    = string
      subnet_address = list(string)

      network_interfaces = list(object({
        network_interface_name = string
        ip_configuration_name = string
      }))
    }))
  }))
}

variable "peering" {
  type = object({
    enabled_peering = bool
    vnet_1_name = string
    vnet_2_name = string
    allow_virtual_network_access = bool
    peer_front = object({
      name = string
      allow_forwarded_traffic_vnet1 = bool
      allow_gateway_transit_vnet1 = bool
      use_remote_gateways_vnet1 = bool
    })
    peer_back = object({
      name = string
      allow_forwarded_traffic_vnet2 = bool
      allow_gateway_transit_vnet2 = bool
      use_remote_gateways_vnet2 = bool
    })
  })
}
