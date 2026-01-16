resource "proxmox_pool" "pools" {
  count = length(var.pool_setup)

  poolid  = var.pool_setup[count.index].poolid != null ? var.pool_setup[count.index].poolid : "pool-${count.index}"
  comment = var.pool_setup[count.index].comment
}

resource "proxmox_vm_qemu" "kvm_proxmox" {

  name                   = var.name
  target_nodes           = var.target_nodes
  description            = var.description
  define_connection_info = var.define_connection_info
  bios                   = var.bios
  start_at_node_boot     = var.start_at_node_boot
  vm_state               = var.vm_state
  protection             = var.protection
  tablet                 = var.tablet
  agent                  = var.agent

  # use VM name from which to clone instead VMID
  clone = var.clone
  # clone_id                     = var.clone_id

  full_clone                = var.full_clone
  hastate                   = var.hastate
  qemu_os                   = var.qemu_os
  memory                    = var.memory
  balloon                   = var.balloon
  hotplug                   = var.hotplug
  scsihw                    = var.scsihw
  pool                      = var.pool
  tags                      = var.tags
  force_create              = var.force_create
  ci_wait                   = var.ci_wait
  ciuser                    = var.ciuser
  cipassword                = var.cipassword
  ciupgrade                 = var.ciupgrade
  searchdomain              = var.searchdomain
  nameserver                = var.nameserver
  sshkeys                   = var.sshkeys
  automatic_reboot          = var.automatic_reboot
  automatic_reboot_severity = var.automatic_reboot_severity
  skip_ipv6                 = var.skip_ipv6
  agent_timeout             = var.agent_timeout
  ipconfig0                 = "ip=dhcp"

  startup_shutdown {
    order            = -1
    shutdown_timeout = -1
    startup_delay    = -1
  }

  cpu {
    cores   = var.cpu_cores
    limit   = var.cpu_limit
    numa    = var.cpu_numa
    sockets = var.cpu_sockets
    type    = var.cpu_type
    units   = var.cpu_units
    vcores  = var.cpu_vcores
  }


  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  dynamic "network" {
    for_each = var.vm_network_setup
    content {
      id        = network.key
      model     = network.value.model
      bridge    = network.value.bridge
      tag       = network.value.tag
      firewall  = network.value.firewall
      mtu       = network.value.mtu
      rate      = network.value.rate
      queues    = network.value.queues
      link_down = network.value.link_down
    }
  }

  # Common disks
  dynamic "disk" {
    for_each = var.vm_disk_setup
    content {
      slot                 = disk.value.slot_name_id
      asyncio              = disk.value.asyncio
      backup               = disk.value.backup
      cache                = disk.value.cache
      discard              = disk.value.discard
      emulatessd           = disk.value.emulatessd
      format               = disk.value.format
      iops_r_burst         = disk.value.iops_r_burst
      iops_r_burst_length  = disk.value.iops_r_burst_length
      iops_r_concurrent    = disk.value.iops_r_concurrent
      iops_wr_burst        = disk.value.iops_wr_burst
      iops_wr_burst_length = disk.value.iops_wr_burst_length
      iops_wr_concurrent   = disk.value.iops_wr_concurrent
      iothread             = var.scsihw == "virtio-scsi-single" ? true : false
      mbps_r_burst         = disk.value.mbps_r_burst
      mbps_r_concurrent    = disk.value.mbps_r_concurrent
      mbps_wr_burst        = disk.value.mbps_wr_burst
      mbps_wr_concurrent   = disk.value.mbps_wr_concurrent
      readonly             = disk.value.readonly
      replicate            = disk.value.replicate
      size                 = disk.value.size
      storage              = disk.value.storage
      type                 = disk.value.type
    }
  }
  # CDROM
  dynamic "disk" {
    for_each = var.vm_cdrom
    content {
      slot = disk.value.slot_name_id
      iso  = disk.value.iso
      type = "cdrom"
    }
  }

  # Cloud Init
  dynamic "disk" {
    for_each = var.vm_cloud_init
    content {
      slot    = disk.value.slot_name_id
      type    = "cloudinit"
      storage = disk.value.storage
    }
  }
}