variable "peering" {
  type = object({
    allow_virtual_network_access = bool
    virtual_networks = list(object({
      name                    = string
      allow_forwarded_traffic = bool
      allow_gateway_transit   = bool
      use_remote_gateways     = bool
    }))
  })
  description = <<DESC
    (Required) Configuration for virtual network peering.
    Properties:
      `allow_virtual_network_access` (Required)   - flag to allow virtual network access
      `virtual_networks` (Required)               - list of virtual networks
        `name` (Required)                      - virtual network name
        `allow_forwarded_traffic` (Required)   - allow forwarded traffic flag
        `allow_gateway_transit` (Required)     - allow gateway transit flag
        `use_remote_gateways` (Required)       - use remote gateways flag
  DESC

  validation {
    condition = length(var.peering.virtual_networks) == 2
    error_message = "Err: virtual networks property MUST have exactly two virtual networks declared."
  }
}

variable "resource_group_name" {
  type        = string
  description = <<DESC
    (Required) Name of the resource group where the virtual networks reside.
  DESC
}