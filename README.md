# terraform-mhenphyz-pmx-vms

Terraform helper module to provide Proxmox (Telmate/proxmox) configuration variables to simplify VM provisioning
## Overview

This module tries to simplify the Telmate/Proxmox usage by converting it to a module and setting some minimum requirements to clone a virtual machine into a new one. 

This is basically a simplified mirror of the project. Most of the arguments supported by Telmate/Proxmox are converted into variable here, allowing the dynamic creation of disks, and network cards.

### Usage

#### 1. Define the module reference to `terraform-mhenphyz-pmx-vms`.

```hcl
module "terraform-mhenphyz-pmx-vms"{
  source       = "terraform-mhenphyz-pmx-vms"
  version      = "v0.0.1"
}
```
#### 2. Set the required arguments for Telmate/Proxmox provider

```hcl
module "terraform-mhenphyz-pmx-vms"{
  source       = "terraform-mhenphyz-pmx-vms"
  version      = "v0.0.1"

  telmate_pmx = {
    pm_api_url      = "https://my_proxmox_server.tld:8006/api2/json"
    pm_tls_insecure = false
  }
}
```

The authentication can be done by providing user and password or token as an argument for the telmate_pmx variable:

```hcl
module "terraform-mhenphyz-pmx-vms"{
  source       = "terraform-mhenphyz-pmx-vms"
  version      = "v0.0.1"

  telmate_pmx = {
    pm_api_url      = "https://my_proxmox_server.tld:8006/api2/json"
    pm_tls_insecure = false

    # USER and PASSWORD
    pm_user         = "terraform_user@pve"
    pm_password     = "change_me@123" ####### CHANGE THIS #######
    
    ##
    ## OR
    ##

    # TOKEN
    pm_api_token_id = "terraform_user@pve!terraform_token_id"
    pm_api_token_secret = "VERY-LONG-STRING"
  }
}
```

Instead you can set an empty `telmate_pmx` variable since all the arguments are set as optional and you can use execution environment variables to replace it:


```bash
$ export PM_API_URL='https://my_proxmox_server.tld:8006/api2/json'

# make sure to use single quotes for the TOKEN ID ;)
$ export PM_API_TOKEN_ID="terraform_user@pve!terraform_token_id" 
$ export PM_API_TOKEN_SECRET='VERY-LONG-STRING'
```

* You can use the official documentation of the provider as [reference](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#argument-reference) for the full argument list or execution environment variables available.*

#### 3. Kickstart 

This example provides the minimum required information to create a virtual machine in proxmox.

1. Set the environment variables as explained before
2. Create a `main.tf` with this content:

```hcl
module "proxmox_vms" {

  source       = "terraform-mhenphyz-pmx-vms"
  version      = "v0.0.1"
  telmate_pmx = {
    pm_tls_insecure = true
  }

  clone        = "Template-Rocky10"
  name         = "dev.rocky01.tld"
  target_nodes = ["pmx01.somewhere.tld"]

}
```
3. Execute terraform init and plan 

```bash
$ terraform init && terraform plan 

Initializing the backend...
Initializing modules...
- proxmox_vms in ../terraform-mhenphyz-pmx-vms
Initializing provider plugins...
- Finding telmate/proxmox versions matching "3.0.2-rc07"...
- Installing telmate/proxmox v3.0.2-rc07...
- Installed telmate/proxmox v3.0.2-rc07 
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.proxmox_vms.proxmox_vm_qemu.kvm_proxmox will be created
  + resource "proxmox_vm_qemu" "kvm_proxmox" {
      ...
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

Then apply it and wait for the 

```bash
$ terraform apply -auto-approve # dont use it in production ;)

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.proxmox_vms.proxmox_vm_qemu.kvm_proxmox will be created
  + resource "proxmox_vm_qemu" "kvm_proxmox" {
      ...
    }

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

### Some examples can be find at [here](/examples/)