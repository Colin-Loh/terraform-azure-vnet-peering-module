# ---------------------------------------------------------------------------------------------------------------------
#  Resource Group
# ---------------------------------------------------------------------------------------------------------------------

resource_group_name     = "rg-terraform-vnet-peer"
resource_group_location = "australiaeast"

# ---------------------------------------------------------------------------------------------------------------------
#  Virtual Networks
# ---------------------------------------------------------------------------------------------------------------------

virtual_networks = {
  "db-vnet" = {
    name = "db-vnet"
    address_space = ["10.0.0.0/16"]

    subnets = [
      {
        subnet_name    = "db-subnet"
        subnet_address = ["10.0.1.0/24"]

        network_interfaces = [
          {
            network_interface_name = "db-nic"
            ip_configuration_name  = "db-ip-configuration"
          }
        ]
      }
    ]
  }
  "app-vnet" = {
    name = "app-vnet"
    address_space = ["10.1.0.0/16"]

    subnets = [
      {
        subnet_name    = "app-subnet"
        subnet_address = ["10.1.2.0/24"]

        network_interfaces = [
          {
            network_interface_name = "app-nic"
            ip_configuration_name  = "app-ip-configuration"
          }
        ]
      }
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
#  Vnet Peering
# ---------------------------------------------------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------------------------------------------------
#  Vnet Peering
# ---------------------------------------------------------------------------------------------------------------------