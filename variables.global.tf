variable "name" {
  type        = string
  description = "The name of the VM within Proxmox."
}

variable "target_nodes" {
  type        = set(string)
  description = "A list of PVE node names on which to place the VM."
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the VM. Shows as the 'Notes' field in the Proxmox GUI."
}

variable "define_connection_info" {
  type        = bool
  default     = true
  description = "Whether to let terraform define the (SSH) connection parameters for preprovisioners, see config block below."
}

variable "bios" {
  type        = string
  default     = "seabios"
  description = "The BIOS to use, options are seabios or ovmf for UEFI."
  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "Please select one of the valid values - 'seabios' or 'ovmf'"
  }
}

variable "start_at_node_boot" {
  type        = bool
  default     = false
  description = "Whether the guest should start automatically when the Proxmox node boots."
}

variable "startup_shutdown" {
  type = map(any)
  default = {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
  }
  description = "Startup and shutdown configuration of the guest, see Startup and Shutdown Reference."
}

variable "vm_state" {
  type        = string
  default     = "running"
  description = "The desired state of the VM. Do note that started will only start the vm on creation and won't fully manage the power state unlike running and stopped do."
  validation {
    condition     = contains(["running", "stopped", "started"], var.vm_state)
    error_message = "Invalid input - Options are running, stopped and started"
  }
}

variable "protection" {
  type        = bool
  default     = false
  description = "Enable/disable the VM protection from being removed. The default value of false indicates the VM is removable."
}

variable "tablet" {
  type        = bool
  default     = true
  description = "Enable/disable the USB tablet device. This device is usually needed to allow absolute mouse positioning with VNC."
}

variable "boot" {
  type        = string
  default     = ""
  description = "The boot order for the VM. For example: order=scsi0;ide2;net0. The deprecated legacy= syntax is no longer supported. See the boot option in the Proxmox manual for more information."
}

variable "bootdisk" {
  type        = string
  default     = ""
  description = "Enable booting from specified disk. You shouldn't need to change it under most circumstances."
}

variable "agent" {
  type        = number
  default     = 1
  description = "Set to 1 to enable the QEMU Guest Agent. Note, you must run the qemu-guest-agent daemon in the guest for this to have any effect."
}

variable "clone" {
  type        = string
  description = "The base VM name from which to clone to create the new VM. Note that clone is mutually exclusive with clone_id and pxe modes."
}

variable "full_clone" {
  type        = bool
  default     = true
  description = "Set to true to create a full clone, or false to create a linked clone. See the docs about cloning for more info. Only applies when clone is set."
}

variable "hastate" {
  type        = string
  default     = "started"
  description = "Requested HA state for the resource. See the docs about HA for more info."
  validation {
    condition     = contains(["started", "stopped", "enabled", "disabled", "ignored"], var.hastate)
    error_message = "Invalid value for 'hastate'. use one of started, stopped, enabled, disabled, or ignored."
  }
}

variable "qemu_os" {
  type        = string
  default     = "l26"
  description = "The type of OS in the guest. Set properly to allow Proxmox to enable optimizations for the appropriate guest OS. It takes the value from the source template and ignore any changes to resource configuration parameter."
  validation {
    condition     = contains(["other", "wxp", "w2k", "w2k3", "w2k8", "wvista", "win7", "win8", "win10", "win11", "l24", "l26", "solaris"], var.qemu_os)
    error_message = "Invalid value for 'qemu_os'. Please select one available"
  }

}

variable "memory" {
  type        = number
  default     = 512
  description = "The amount of memory to allocate to the VM in Megabytes."
}

variable "balloon" {
  type        = number
  default     = 0
  description = "The minimum amount of memory to allocate to the VM in Megabytes, when Automatic Memory Allocation is desired. Proxmox will enable a balloon device on the guest to manage dynamic allocation. See the docs about memory for more info."
}

variable "hotplug" {
  type        = string
  default     = 0
  description = "disk,usb,Comma delimited list of hotplug features to enable. Options: network, disk, cpu, memory, usb. Set to 0 to disable hotplug."
}

variable "scsihw" {
  type        = string
  default     = "virtio-scsi-single"
  description = "The SCSI controller to emulate."
  validation {
    condition     = contains(["lsi", "lsi53c810", "megasas", "pvscsi", "virtio-scsi-pci", "virtio-scsi-single"], var.scsihw)
    error_message = "Invalid value for 'scsihw'. Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single."
  }
}

variable "pool" {
  type        = string
  default     = ""
  description = "The resource pool to which the VM will be added."
}

variable "tags" {
  type        = string
  default     = ""
  description = "Tags of the VM. Comma-separated values (e.g. tag1,tag2,tag3). Tag may not start with - and may only include the following characters: [a-z], [0-9], _ and -. This is only meta information."
}

variable "force_create" {
  type        = bool
  default     = false
  description = "If false, and a vm of the same name, on the same node exists, terraform will attempt to reconfigure that VM with these settings. Set to true to always create a new VM (note, the name of the VM must still be unique, otherwise an error will be produced.)"
}

variable "force_recreate_on_change_of" {
  type        = string
  default     = ""
  description = "If the value of this string changes, the VM will be recreated. Useful for allowing this resource to be recreated when arbitrary attributes change. An example where this is useful is a cloudinit configuration (as the cicustom attribute points to a file not the content)."
}

variable "ci_wait" {
  type        = number
  default     = 60
  description = "How to long in seconds to wait for before provisioning."
}

variable "ciuser" {
  type        = string
  default     = ""
  description = "Override the default cloud-init user for provisioning."
}

variable "cipassword" {
  type        = string
  default     = ""
  description = "Override the default cloud-init user's password. Sensitive."
}

variable "ciupgrade" {
  type        = bool
  default     = true
  description = "Whether to upgrade the packages on the guest during provisioning. Restarts the VM when set to true."
}

variable "searchdomain" {
  type        = string
  default     = ""
  description = "Sets default DNS search domain suffix."
}

variable "nameserver" {
  type        = string
  default     = ""
  description = "Sets default DNS server for guest."
}

variable "sshkeys" {
  type        = string
  default     = ""
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user."
}

variable "automatic_reboot" {
  type        = bool
  default     = true
  description = "Automatically reboot the VM when parameter changes require this. If disabled the provider will emit a warning or error when the VM needs to be rebooted, this can be configured with automatic_reboot_severity."
}

variable "automatic_reboot_severity" {
  type        = string
  default     = "error"
  description = "Sets the severity of the error/warning when automatic_reboot is false. Values can be error or warning."
}

variable "skip_ipv4" {
  type        = bool
  default     = false
  description = "Tells proxmox that acquiring an IPv4 address from the qemu guest agent isn't required, it will still return an ipv4 address if it could obtain one. Useful for reducing retries in environments without ipv4."
}

variable "skip_ipv6" {
  type        = bool
  default     = true
  description = "Tells proxmox that acquiring an IPv6 address from the qemu guest agent isn't required, it will still return an ipv6 address if it could obtain one. Useful for reducing retries in environments without ipv6."
}

variable "agent_timeout" {
  type        = number
  default     = 90
  description = "Timeout in seconds to keep trying to obtain an IP address from the guest agent one we have a connection."
}

variable "disk_cdrom" {
  type        = map(any)
  default     = {}
  description = "The name of the ISO image to mount to the VM in the format: [storage pool]:iso/[name of iso file]. Note that iso is mutually exclusive with passthrough."
}

variable "disk_cloud_init_storage" {
  type        = string
  default     = "local"
  description = "The name of the storage pool on which to store the cloud-init drive. Required when using cloud-init."
}

#
# Pools Variable
#

variable "pool_setup" {
  type = list(
    object({
      poolid  = optional(string)     # The name for the new pool
      comment = optional(string, "") # Optional comment for the pool 
    })
  )
  default = []
}