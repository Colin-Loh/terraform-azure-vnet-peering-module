#Module      : Virtual Network Peering
#Description : This wil automatically take care of the peering between the two virtual networks.

variable "resource_group_name" {
  type = string
  description = "value for resource group name"
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

  description = "values for peering"
}


variable "vnet_2_id" {
  type        = string
  description = "value of the remote virtual network id"
}

variable "vnet_1_id" {
  type        = string
  description = "value of the remote virtual network id"
}
