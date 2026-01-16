variable "cpu_cores" {
  type        = number
  default     = 1
  description = "The number of CPU cores to allocate to the Qemu guest."
  validation {
    condition     = var.cpu_cores >= 1
    error_message = "The number of cpu cores needs to equal or bigger than 1"
  }
}
variable "cpu_limit" {
  type        = number
  default     = 0
  description = "The CPU limit for the Qemu guest. 0 means unlimited."
  validation {
    condition     = var.cpu_limit >= 0
    error_message = "The number of cpu limit needs to equal or bigger than 0"
  }
}
variable "cpu_numa" {
  type        = bool
  default     = false
  description = "Whether to enable Non-Uniform Memory Access in the Qemu guest."
}
variable "cpu_sockets" {
  type        = number
  default     = 1
  description = "The number of CPU sockets to allocate to the Qemu guest."
  validation {
    condition     = var.cpu_sockets >= 1
    error_message = "The number of cpu sockets needs to equal or bigger than 1"
  }
}
variable "cpu_type" {
  type        = string
  default     = "x86-64-v2"
  description = "The CPU type to emulate. See the docs about CPU Types for more info."
  validation {
    condition = contains(["athlon", "EPYC", "EPYC-Genoa", "EPYC-IBPB", "EPYC-Milan", "EPYC-Milan-v2", "EPYC-Rome", "EPYC-Rome-v2", "EPYC-Rome-v3", "EPYC-Rome-v4", "EPYC-v3", "EPYC-v4", "Opteron_G1", "Opteron_G2", "Opteron_G3", "Opteron_G4", "Opteron_G5", "phenom", "486", "Broadwell", "Broadwell-IBRS", "Broadwell-noTSX", "Broadwell-noTSX-IBRS", "Cascadelake-Server", "Cascadelake-Server-noTSX", "Cascadelake-Server-v2", "Cascadelake-Server-v4", "Cascadelake-Server-v5", "Conroe", "Cooperlake", "Cooperlake-v2", "core2duo", "coreduo", "GraniteRapids", "Haswell", "Haswell-IBRS", "Haswell-noTSX", "Haswell-noTSX-IBRS", "Icelake-Client", "Icelake-Client-noTSX", "Icelake-Server", "Icelake-Server-noTSX", "Icelake-Server-v3", "Icelake-Server-v4", "Icelake-Server-v5", "Icelake-Server-v6", "IvyBridge", "IvyBridge-IBRS", "KnightsMill", "Nehalem", "Nehalem-IBRS", "Penryn", "pentium", "pentium2", "pentium3", "SandyBridge", "SandyBridge-IBRS", "SapphireRapids", "SapphireRapids-v2", "Skylake-Client", "Skylake-Client-IBRS", "Skylake-Client-noTSX-IBRS", "Skylake-Client-v4", "Skylake-Server", "Skylake-Server-IBRS", "Skylake-Server-noTSX-IBRS", "Skylake-Server-v4", "Skylake-Server-v5", "Westmere", "Westmere-IBRS", "kvm32", "kvm64", "max", "qemu32", "qemu64", "x86-64-v2", "x86-64-v2-AES", "x86-64-v3", "x86-64-v4", "host"]
    , var.cpu_type)
    error_message = "The informed CPU type is not valid."
  }
}
variable "cpu_units" {
  type        = number
  default     = 0
  description = "The CPU units for the Qemu guest. This is a relative value which defines the CPU weight of the Qemu guest. The default value of 0 indicates the PVE default is used."
  validation {
    condition     = var.cpu_units >= 0
    error_message = "The number of cpu units needs to equal or bigger than 0"
  }
}
variable "cpu_vcores" {
  type        = number
  default     = 0
  description = "The number of virtual cores exposed to the Qemu guest. If 0, this is set automatically by Proxmox to sockets * cores. "
  validation {
    condition     = var.cpu_vcores >= 0
    error_message = "The number of virtual cores needs to equal or bigger than 0"
  }
}
