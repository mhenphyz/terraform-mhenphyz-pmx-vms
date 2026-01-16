# Custom Virtual Machine Resources.

This example shows how to customize some basic configurations, like ammount of resources and CPU type required for Rocky Linux in proxmox

```hcl
module "proxmox_vms" {

  source       = "mhenphyz/pmx-vms/mhenphyz"
  version      = "v1.0.1"
  telmate_pmx = {
    pm_tls_insecure = true
  }


  clone        = "Template-Rocky10" # Set the name of the virtual machine template to clone the image
  name         = "myvm.rocky10.tld" # New hostname for the VM
  target_nodes = ["pmx01-home"]     # List of Nodes where the VM can be deployed
  memory       = 2048 
  cpu_cores    = 2
  cpu_sockets  = 2
  cpu_type = "x86-64-v3"            # CPU required to allow Rocky to boot in proxmox


  # Dual Disk Setup Configuration
  vm_disk_setup = [{
    size         = "10G"
    storage      = "local"
    slot_name_id = "scsi0"
    type         = "disk"
    },
    {
      size         = "1G"
      storage      = "local"
      slot_name_id = "scsi1"
      type         = "disk"
  }]

  vm_network_setup = [{
    bridge = "lanlab"
  }]

}
```