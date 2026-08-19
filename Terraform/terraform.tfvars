// What this file does
# Sets variables that will be called to in main.tf
# This is to have version control and minium edits to the main.tf files for common changes

// Internet Resource for creating vSphere Clones using Terraform
# https://sdorsett.github.io/post/2018-12-24-using-terraform-to-clone-a-virtual-machine-on-vsphere/

//Terraform settings
role = "test"

// Troubleshooting Terraform
## TF_LOG to one of the log levels (in order of decreasing verbosity) to change the verbosity of the logs
## TS_LOG OPtions: trace / debug / info / warn / error
#export TF_LOG=trace
#export TF_LOG_PATH="./terraform.log"

// Vault information that will be used to pull passwords for the declared user ID in vault
vault_address          = "http://10.32.0.17:8200"
vault_path_vsphere     = "C2Net/Platform/vsphere"
vault_path_local_admin = "C2Net/Platform/windows_local_admin"
vault_path_ad_join     = "C2Net/Platform/ad_join"

//VM vSphere target template info that PACKER will pull from to use
template_folder      = "_Deployments/Windows-11-Dev"
vm_template_name     = "Win11-Dev_02-03-2026_24H2_LTSC"
network_waiter       = "0" # How long to wait for network interface to come online. Unit: minutes. Set to 0 (zero) to disable
creating_timeout     = "30" # Controls 'Still Creating...' timeout. Unit: minutes. Set to 0 (zero) to disable

//VM vSphere Hardware info ## https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/virtual_machine
hostname                 = "Win11-Test-Genesis" # 15 Character limit
vm_cpu_count             = "4"
vm_ram_size              = "16384" # Meatured in MB (MegaBytes)
vm_disk_size             = "100" # Meatured in GB (GigaBytes)
vm_disk_label            = "Hard disk 1"
vm_guest_os_type         = "windows11_64Guest"
vm_firmware              = "efi" # Windows OS require set to "EFI" or else it will go back to "BIOS" and not load the OS
datastore                = "c2san01" # Will need to be accessible from the picked vSphere cluster
network_name             = "VMs-20"
vm_network_card          = "e1000e" # Check Template: vSphere > Select VM > Edit Settings > Network Adapter > Adapter Type ## Options: "e1000" "e1000e" "sriov" "vmxnet3" "vmxnet3vrdma"
ipv4_address_static      = "" # Check if configured: main.tf >> resource "vsphere_virtual_machine" "deploy_vm" >> clone >> customize >> network_interface
ipv4_netmask             = "" # Use CIDR Notation (EX: 24 = 255.255.255.0) # Check if configured: main.tf >> resource "vsphere_virtual_machine" "deploy_vm" >> clone >> customize >> network_interface

//vSphere Settings
vsphere_endpoint            = "10.32.0.30"
vsphere_username            = "Administrator@vsphere.local" # Will be used to query vault for username at vault_path_vsphere
vsphere_password            = "THIS WILL FAIL" # Keeping variable just in case Vault doesn't exist
vsphere_insecure_connection = true

//VM vSphere Configuration info
datacenter         = "HSV"
cluster            = "POCIT"
resource_pool      = "POCIT-User"
dest_folder        = "User/Genesis-Test-VMs"

//VM vSphere Snapshot Settings
# Info for making Snapshots in Terraform:
# https://developer.hashicorp.com/terraform/tutorials/virtual-machine/vsphere-provider#create-a-snapshot
# https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine_snapshot.html
snapshot_name         = "Horizon-Snapshot-TF-Test"
snapshot_description  = "Created-using-C2Net-Pipeline"

//Active Directory settings done by account with the ability to join computers to the domain
# Internet Resource: https://www.reddit.com/r/Terraform/comments/pb7psf/join_vm_to_domain/
# Internet Resource: https://tekanaid.com/posts/terraform-vsphere-windows-example-to-join-ad-domain/
# Internet Resource: https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine
domain_name           = "c2.dev"
domain_admin_user     = "yyterraform" # Will be used to query vault for username at vault_path_ad_join
domain_admin_password = "THIS WILL FAIL" # Keeping variable just in case Vault doesn't exist
domain_ou             = "OU=Dev,OU=Windows,OU=Workstations,DC=c2,DC=dev" # There is what OU the computer will be placed into by the domain_admin_user account

//Windows OS configuration done by Local Windows Administrator account
auto_logon            = true
local_admin_username  = "Administrator" # Will be used to query vault for username at vault_path_local_admin
local_admin_password  = "THIS WILL FAIL" # Keeping variable just in case Vault doesn't exist
auto_logon_count      = "2"
#product_key           = "NHB69-V77PJ-F86MF-2DHCK-66RQV"

## Will run in the order below
# Heavily relies on GPOs to enforce STIGs and management of Local Group Permissions.
# Internet Resource: using "run_once_command_list": https://anthonyspiteri.net/powershell-with-terraform/
run_once_command_list = [
"cmd.exe /C Powershell.exe -Command gpupdate /force",
"cmd.exe /C Powershell.exe -Command Restart-Computer -Force"
]