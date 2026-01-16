variable "vm_network_setup" {
  type = list(
    object(
      {
        model     = optional(string, "virtio") # Required Network Card Model. The virtio model provides the best performance with very low CPU overhead.
        bridge    = optional(string, "vmbr0")  # Bridge to which the network device should be attached. The Proxmox VE standard bridge is called vmbr0.
        tag       = optional(number, 0)        # The VLAN tag to apply to packets on this device. 0 disables VLAN tagging.
        firewall  = optional(bool, true)       # Whether to enable the Proxmox firewall on this network device.
        mtu       = optional(number, 1500)     # The MTU value for the network device. On virtio models, set to 1 to inherit the MTU value from the underlying bridge.
        rate      = optional(number, 0)        # "Network device rate limit in mbps (megabytes per second) as floating ponumber number. Set to 0 to disable rate limiting.
        queues    = optional(number, 0)        # Number of packet queues to be used on the device. Requires virtio model to have an effect.
        link_down = optional(bool, false)      # Whether this interface should be disconnected (like pulling the plug).
      }
    )
  )

  ####
  #### Validations
  ####

  # nic model
  validation {
    condition = alltrue([
      for item in var.vm_network_setup : contains([
        "e1000", "e1000-82540em", "e1000-82544gc", "e1000-82545em", "i82551", "i82557b", "i82559er", "ne2k_isa", "ne2k_pci", "pcnet", "rtl8139", "virtio", "vmxnet3"
      ], item.model)
    ])
    error_message = "Invalid option for 'net_model'. Options: e1000, e1000-82540em, e1000-82544gc, e1000-82545em, i82551, i82557b, i82559er, ne2k_isa, ne2k_pci, pcnet, rtl8139, virtio, vmxnet3."
  }

  # vlan tag
  validation {
    condition = alltrue([
      for item in var.vm_network_setup : item.tag >= 0 && item.tag <= 4096
    ])
    error_message = "Required value for 'net_tag' need to be within 0-4096 "
  }

  # nic mtu
  validation {
    condition = alltrue([
      for item in var.vm_network_setup : item.mtu > 0 && item.mtu <= 9000
    ])
    error_message = "Required value for 'net_mtu' is too big or invalid, needs to be between 1 and 9k"
  }

  ####
  #### Default - At least one NIC on default bridge
  ####

  default = [{
    bridge = "vmbr0"
  }]
}
