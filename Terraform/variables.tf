/*
    Defined Variable Blocks for use in tfvars files.

    Variables need to be used or have a defined default value.
*/
variable "vault_token" {
  type        = string
  description = "Vault Server Token"
  default     = "hvs.JCmJMxt7BJixT0cREwsZwixb" 
}

// Custom Variables
variable "role" {
  type        = string
  description = "Name of Role"
}

variable "creating_timeout" {
  type        = number
  description = "The timeout for how long 'Still creating...' will last. Units in minutes"
  default     = 10
}

variable "network_waiter" {
  type        = number
  description = "Waits for interfaces to appear on a virtual machine guest operating system. Units in minutes"
  default     = 10
}

// Vault secret information
variable "vault_address" {
  type        = string
  description = "API URL for Vault Server to pull information for vault paths"
  sensitive   = true
}

variable "vault_path_vsphere" {
  type        = string
  description = "Path to Secret for vSphere to create VM"
  sensitive   = true
}

variable "vault_path_local_admin" {
  type        = string
  description = "Path to Secret for Local Administrator account on Windows image"
  sensitive   = true
}

variable "vault_path_ad_join" {
  type        = string
  description = "Path to Secret for Domain account with Permissions to join machine to domain"
  sensitive   = true
}

// Snapshot Variables
variable "snapshot_name" {
  type        = string
  description = "Name of Snapshot"
}

variable "snapshot_description" {
  type        = string
  description = "Info about Snapshot"
}

// Active Directory joining info

variable "domain_name" {
  type        = string
  description = "Domain name for OS"
  sensitive   = true
}

variable "domain_admin_user" {
  type        = string
  description = "The user account with administrative privileges to use to join the guest operating system to the domain. Required if setting join_domain"
  sensitive   = true
}

variable "domain_admin_password" {
  type        = string
  description = "The password user account with administrative privileges used to join the virtual machine to the domain. Required if setting join_domain"
  sensitive   = true
}

variable "domain_ou" {
  type        = string
  description = "The MachineObjectOU which specifies the full LDAP path name of the OU to which the virtual machine belongs"
  sensitive   = true
}


//Windows OS related settings
variable "product_key" {
  type        = string
  description = "The product key for the virtual machine Windows guest operating system. The default is no key"
  default     = null
}

variable "auto_logon_count" {
  type        = number
  description = "Specifies how many times the virtual machine should auto-logon the Administrator account when auto_logon is true. This option should be set accordingly to ensure that all of your commands that run in run_once_command_list can log in to run"
  default     = 1
}

variable "auto_logon" {
  type        = bool
  description = "Specifies whether or not the virtual machine automatically logs on as Administrator."
  default     = false
}

variable "local_admin_username" {
  type        = string
  description = "The administrator Username for the virtual machine"
  sensitive   = true
  default     = "Administrator"
}

variable "local_admin_password" {
  type        = string
  description = "The administrator password for the virtual machine"
  sensitive   = true
  default     = null
}

variable "run_once_command_list" {
  type        = list(string)
  description = "A list of commands to run at first user logon, after guest customization. Each run once command is limited by the API to 260 characters"
  default     = null
}

// vSphere Credentials

variable "vsphere_endpoint" {
  type        = string
  description = "vCenter FQDN or IP."
  sensitive   = true
}

variable "vsphere_username" {
  type        = string
  description = "vCenter user."
  sensitive   = true
  #default     = "Administrator@vsphere.local"
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_insecure_connection" {
  type        = bool
  description = "Skip TLS verification."
  default     = true
}

// vSphere Settings

variable "datacenter" {
  type        = string
  description = "The name of the target vSphere datacenter."
  #default     = ""
  #sensitive   = true
}

variable "cluster" {
  type        = string
  description = "The name of the target vSphere cluster."
  #default     = ""
  #sensitive   = true
}

variable "host" {
  type        = string
  description = "The name of the target ESXi host."
  default     = ""
  sensitive   = true
}

variable "datastore" {
  type        = string
  description = "The name of the target vSphere datastore."
  #sensitive   = true
}

variable "template_folder" {
  type        = string
  description = "Full Path to Template Folder"
  #sensitive   = true
}

variable "network_name" {
  type        = string
  description = "The name of the target vSphere network segment."
  #sensitive   = true
}

variable "dest_folder" {
  type        = string
  description = "The name of the target vSphere folder."
  #default     = ""
  #sensitive   = true
}

variable "resource_pool" {
  type        = string
  description = "The name of the target vSphere resource pool."
  #default     = ""
  #sensitive   = true
}

// Virtual Machine Settings

variable "hostname" {
  type        = string
  description = "Hostname for OS"
}

variable "vm_template_name" {
  type        = string
  description = "Template Name."
  sensitive   = true
}

variable "vm_guest_os_type" {
  type        = string
  description = "Guest ID (e.g. windows11_64Guest)."
}

variable "vm_guest_os_cloudinit" {
  type        = bool
  description = "Enable cloud-init for the guest operating system."
  default     = false
}

variable "vm_firmware" {
  type        = string
  description = "The virtual machine firmware. EFI or BIOS."
  default     = "efi"
}

variable "vm_cdrom_type" {
  type        = string
  description = "The virtual machine CD-ROM type."
  default     = "sata"
}

variable "vm_cdrom_count" {
  type        = string
  description = "The number of virtual CD-ROMs remaining after the build."
  default     = 1
}

variable "vm_cpu_count" {
  type        = number
  description = "The number of virtual CPUs."
  default     = 4  
}

variable "vm_cpu_cores" {
  type        = number
  description = "The number of virtual CPUs cores per socket."
  default     = 1
}

variable "vm_cpu_hot_add" {
  type        = bool
  description = "Enable hot add CPU."
  default     = false
}

variable "vm_ram_size" {
  type        = number
  description = "The size for the virtual memory in MB."
  default     = 16384
}

variable "vm_mem_hot_add" {
  type        = bool
  description = "Enable hot add memory."
  default     = false
}

variable "vm_disk_label" {
  type        = string
  description = "Naming the Disk for the VM"
  default     = "disk0"
}

variable "vm_disk_size" {
  type        = number
  description = "The size for the virtual disk in MB."
  default     = 100
}

variable "vm_disk_controller_type" {
  type        = list(string)
  description = "The virtual disk controller types in sequence."
  default     = ["pvscsi"]
}

variable "vm_disk_thin_provisioned" {
  type        = bool
  description = "Thin provision the virtual disk."
  default     = true
}

variable "vm_network_card" {
  type        = string
  description = "The virtual network card type."
  default     = "e1000e"
}

variable "ipv4_address_static" {
  type        = string
  description = "Set the IPv4 address"
  default     = ""
  sensitive   = true
}

variable "ipv4_netmask" {
  type        = string
  description = "Set the IPv4 Subnet mask for IPv4 address"
  default     = ""
  sensitive   = true
}

variable "common_tools_upgrade_policy" {
  type        = bool
  description = "Upgrade VMware Tools on reboot."
  default     = true
}

variable "common_remove_cdrom" {
  type        = bool
  description = "Remove the virtual CD-ROM(s)."
  default     = true
}

// Template and Content Library Settings

variable "common_template_conversion" {
  type        = bool
  description = "Convert the virtual machine to template. Must be 'false' for content library."
  default     = false
}

variable "common_content_library_enabled" {
  type        = bool
  description = "Import the virtual machine into the vSphere content library."
  default     = true
}

variable "common_content_library" {
  type        = string
  description = "The name of the target vSphere content library, if enabled."
  default     = null
}

variable "common_content_library_ovf" {
  type        = bool
  description = "Export to content library as an OVF template."
  default     = true
}

variable "common_content_library_destroy" {
  type        = bool
  description = "Delete the virtual machine after exporting to the content library."
  default     = true
}

variable "common_content_library_skip_export" {
  type        = bool
  description = "Skip exporting the virtual machine to the content library. Option allows for testing/debugging without saving the machine image."
  default     = false
}

// OVF Export Settings

variable "common_ovf_export_enabled" {
  type        = bool
  description = "Enable OVF artifact export."
  default     = false
}

variable "common_ovf_export_overwrite" {
  type        = bool
  description = "Overwrite existing OVF artifact."
  default     = true
}

// Removable Media Settings

variable "common_iso_content_library_enabled" {
  type        = bool
  description = "Import the guest operating system ISO into the vSphere content library."
  default     = false
}

// Communicator Settings and Credentials

variable "communicator_proxy_host" {
  type        = string
  description = "The proxy server to use for SSH connection. (Optional)"
  default     = null
}

variable "communicator_proxy_port" {
  type        = number
  description = "The port to connect to the proxy server. (Optional)"
  default     = null
}

variable "communicator_proxy_username" {
  type        = string
  description = "The username to authenticate with the proxy server. (Optional)"
  default     = null
}

variable "communicator_proxy_password" {
  type        = string
  description = "The password to authenticate with the proxy server. (Optional)"
  sensitive   = true
  default     = null
}

variable "communicator_port" {
  type        = number
  description = "The port for the communicator protocol."
  default     = 22
}

variable "communicator_timeout" {
  type        = string
  description = "The timeout for the communicator protocol."
  default     = "30m"
}