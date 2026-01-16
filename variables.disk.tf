variable "vm_disk_setup" {
  description = "List of Disks to Attach to the virtual Machine"
  type = list(
    object(
      {
        size         = string # The size of the created disk. Accepts K for kibibytes, M for mebibytes, G for gibibytes, T for tibibytes. When only a number is provided gibibytes is assumed.
        storage      = string # The name of the storage pool on which to store the disk.
        slot_name_id = string # The slot id of the disk 
        type         = string # The type of disk to create

        #####################################################
        ### All disk common optional options, can be customized
        #####################################################

        asyncio              = optional(string, "io_uring")  # The drive's asyncio setting.
        backup               = optional(bool, true)          # Whether the drive should be included when making backups.
        cache                = optional(string, "writeback") # The drive’s cache mode.
        discard              = optional(bool, false)         # Controls whether to pass discard/trim requests to the underlying storage. Only effective when the underlying storage supports thin provisioning. There are other caveats too, see the docs about disks for more info.
        emulatessd           = optional(bool, true)          # Whether to expose this drive as an SSD, rather than a rotational hard disk.
        format               = optional(string, "qcow2")     # The drive’s backing file’s data format.
        iops_r_burst         = optional(number, 0)           # Maximum number of iops while reading in short bursts. 0 means unlimited.
        iops_r_burst_length  = optional(number, 0)           # Length of the read burst duration in seconds. 0 means the default duration dictated by proxmox.
        iops_r_concurrent    = optional(number, 0)           # Maximum number of iops while reading concurrently. 0 means unlimited.
        iops_wr_burst        = optional(number, 0)           # Maximum number of iops while writing in short bursts. 0 means unlimited.
        iops_wr_burst_length = optional(number, 0)           # Length of the write burst duration in seconds. 0 means the default duration dictated by proxmox.
        iops_wr_concurrent   = optional(number, 0)           # Maximum number of iops while writing concurrently. 0 means unlimited.
        mbps_r_burst         = optional(number, 0.0)         # Maximum read speed in megabytes per second. 0 means unlimited.
        mbps_r_concurrent    = optional(number, 0.0)         # Maximum read speed in megabytes per second. 0 means unlimited.
        mbps_wr_burst        = optional(number, 0.0)         # Maximum write speed in megabytes per second. 0 means unlimited.
        mbps_wr_concurrent   = optional(number, 0.0)         # Maximum throttled write pool in megabytes per second. 0 means unlimited.
        readonly             = optional(bool, false)         # Whether the drive should be readonly
        replicate            = optional(bool, false)         # Whether the drive should considered for replication jobs.
      }
    )
  )

  ####
  #### Validations
  ####

  # asyncio
  validation {
    condition = alltrue([
    for item in var.vm_disk_setup : contains(["io_uring", "native", "threads"], item.asyncio)])
    error_message = "Invalid value for 'disks_asyncio'. Options: io_uring, native, threads"
  }
  # cache
  validation {
    condition = alltrue([
    for item in var.vm_disk_setup : contains(["directsync", "none", "unsafe", "writeback", "writethrough"], item.cache)])
    error_message = "Invalid value for 'disks_cache'. Options: directsync, none, unsafe, writeback, writethrough."
  }
  # format
  validation {
    condition = alltrue([
    for item in var.vm_disk_setup : contains(["raw", "qcow2", "vmdk"], item.format)])
    error_message = "Invalid value for 'disks_format'. Options: raw, qcow2, vmdk"
  }
  # slot name + id
  validation {
    condition = alltrue([
      for item in var.vm_disk_setup : contains([
        # "ide0", "ide1", "ide2","ide3", # Reserve ide for cloud-init and cdrom can be a good option ;)
        "sata0", "sata1", "sata2", "sata3", "sata4", "sata5",
        "scsi0", "scsi1", "scsi2", "scsi3", "scsi4", "scsi5", "scsi6", "scsi7", "scsi8", "scsi9", "scsi10", "scsi11", "scsi12", "scsi13", "scsi14", "scsi15", "scsi16", "scsi17", "scsi18", "scsi19", "scsi20", "scsi21", "scsi22", "scsi23", "scsi24", "scsi25", "scsi26", "scsi27", "scsi28", "scsi29", "scsi30",
        "virtio0", "virtio1", "virtio2", "virtio3", "virtio4", "virtio5", "virtio6", "virtio7", "virtio8", "virtio9", "virtio10", "virtio11", "virtio12", "virtio13", "virtio14", "virtio15"
    ], item.slot_name_id)])
    error_message = "The slot id of the disk - must be one of 'ide0', 'ide1', 'ide2', 'ide3', 'sata0', 'sata1', 'sata2', 'sata3', 'sata4', 'sata5', 'scsi0', 'scsi1', 'scsi2', 'scsi3', 'scsi4', 'scsi5', 'scsi6', 'scsi7', 'scsi8', 'scsi9', 'scsi10', 'scsi11', 'scsi12', 'scsi13', 'scsi14', 'scsi15', 'scsi16', 'scsi17', 'scsi18', 'scsi19', 'scsi20', 'scsi21', 'scsi22', 'scsi23', 'scsi24', 'scsi25', 'scsi26', 'scsi27', 'scsi28', 'scsi29', 'scsi30', 'virtio0', 'virtio1', 'virtio2', 'virtio3', 'virtio4', 'virtio5', 'virtio6', 'virtio7', 'virtio8', 'virtio9', 'virtio10', 'virtio11', 'virtio12', 'virtio13', 'virtio14', 'virtio15'"
  }
  # type
  validation {
    condition = alltrue([
    for item in var.vm_disk_setup : contains(["cdrom", "cloudinit", "disk", "ignore"], item.type)])
    error_message = "Invalid disk type. Options: cdrom, cloudinit, disk, ignore"
  }

  ####
  #### Default - At least one Disk of 10G
  ####

  default = [{
    format       = "qcow2"
    size         = "10G"
    storage      = "local"
    slot_name_id = "scsi0"
    type         = "disk"
  }]
}

variable "vm_cloud_init" {
  description = "List of Disks to Attach to the virtual Machine"
  type = list(
    object(
      {
        slot_name_id = optional(string, "") # The slot id of the disk  = string
        storage      = string
      }
    )
  )
  # slot name + id validation
  validation {
    condition = alltrue([
      for item in var.vm_cloud_init : contains([
        "ide0", "ide1", "ide2", "ide3", "scsi29", "scsi30" # Reserve ide for cloud-init and cdrom can be a good option ;)
    ], item.slot_name_id)])
    error_message = "The reserved slot id for cloud-init and crdrom must be one of 'ide0', 'ide1', 'ide2', 'ide3'"
  }
  default = [{
    slot_name_id = "scsi30"
    storage      = "local"
  }]
}

variable "vm_cdrom" {
  description = "List of CDROM to Attach to the virtual Machine"
  type = list(
    object(
      {
        slot_name_id = optional(string, "") # The slot id of the disk  = string
        iso          = optional(string, "") # The name of the ISO image to mount to the VM in the format: [storage pool]:iso/[name of iso file]
      }
    )
  )
  # slot name + id validation
  validation {
    condition = alltrue([
      for item in var.vm_cdrom : contains([
        "ide0", "ide1", "ide2", "ide3", "scsi29", "scsi30" # Reserve ide for cloud-init and cdrom can be a good option ;)
    ], item.slot_name_id)])
    error_message = "The reserved slot id for cloud-init and crdrom must be one of 'ide0', 'ide1', 'ide2', 'ide3'"
  }
  validation {
    condition = alltrue([
    for item in var.vm_cdrom : item.iso == "" || can(regex("^[^:]+:iso\\/.+\\.iso$", item.iso))])
    error_message = "A string da ISO deve seguir o formato '[storage]:iso/[arquivo.iso]' (ex: local:iso/debian.iso)."
  }

  default = [{
    slot_name_id = "scsi29"
  }]
}