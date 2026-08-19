terraform {
  required_providers {

    vault = {
      source  = "hashicorp/vault"
      version = "5.6.0"  
    }

    vsphere = {
      source = "vmware/vsphere"
      version = "2.10.0"
    }
  }
}

// Using VAULT with Terraform note
# internet info about VAULT provider: https://registry.terraform.io/providers/hashicorp/vault/latest/docs 
provider "vault" {
  address          = var.vault_address
  token            = var.vault_token
  skip_tls_verify  = true
  skip_child_token = true
}

# Grabs VAULT info for vSphere account
data "vault_generic_secret" "vsphere" {
  path = var.vault_path_vsphere
}

# Grabs VAULT info for Local Windows Admin Password
data "vault_generic_secret" "local_admin" {
  path = var.vault_path_local_admin
}

# Grabs VAULT info for Service account that would join computer to AD
data "vault_generic_secret" "ad_join" {
  path = var.vault_path_ad_join
}

provider "vsphere" {
  user                 = var.vsphere_username
  password             = data.vault_generic_secret.vsphere.data["${var.vsphere_username}"]
  vsphere_server       = var.vsphere_endpoint
  allow_unverified_ssl = var.vsphere_insecure_connection
}

// Retrieve Template information from vSphere
# Pulls in data that will be used in data.vsphere_datacenter.datacenter.id
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" { 
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template_folder}/${var.vm_template_name}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "deploy_vm" {
  name                 = var.hostname
  folder               = var.dest_folder

  guest_id             = var.vm_guest_os_type
  firmware             = var.vm_firmware
  
  resource_pool_id     = data.vsphere_resource_pool.pool.id
  datastore_id         = data.vsphere_datastore.datastore.id

  num_cpus             = var.vm_cpu_count
  memory               = var.vm_ram_size

  wait_for_guest_net_timeout = var.network_waiter
  wait_for_guest_ip_timeout  = var.network_waiter

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = var.vm_network_card
  }

  disk {
    label = var.vm_disk_label
    size  = var.vm_disk_size
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {

       // Extend the overall customization timeout to Number of minutes (EX: 20 minutes)
      timeout = var.creating_timeout

      # Referance to windows_options: https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine
      windows_options {
        computer_name          = var.hostname
        join_domain            = var.domain_name

        domain_admin_user      = var.domain_admin_user
        domain_admin_password  = data.vault_generic_secret.ad_join.data["${var.domain_admin_user}"] #Will reach out to VAULT to pull password

        auto_logon             = var.auto_logon
        auto_logon_count       = var.auto_logon_count
        admin_password         = data.vault_generic_secret.local_admin.data["${var.local_admin_username}"] #Will reach out to VAULT to pull password
        
        product_key            = var.product_key
        domain_ou              = var.domain_ou
        run_once_command_list  = var.run_once_command_list
        #organization_name      = var.domain_name
      }
      
      // network_interface: Do not comment out completely, even if EMPTY
      network_interface {
      ## Use below if a STATIC Network information is needed to be set
      ## Comment out below two lines if not needed / Let machine get DHCP address
      #  ipv4_address = var.ipv4_address_static
      #  ipv4_netmask = var.ipv4_netmask
      }
    }
  }
}

// Make Snapshots for VMs
### If creating a NEW VM, will need to comment out the below logic, or will get the following errors
# ""...has not been declared in the root module" // This is due to 'data.vsphere_virtual_machine.deploy_vm.id' being EMPTY on a fresh Terraform init
# "error fetching virtual machine: vm '<Data in var.hostname>' not found" // This is due to the VM not existing yet and terraform can't find the VM name in Horizon
## To work around this, need to use the 'depends_on' argument
# Info link: https://developer.hashicorp.com/terraform/tutorials/configuration-language/dependencies#manage-explicit-dependencies

// Retrieve VM Info
data "vsphere_virtual_machine" "deployed_vm"{
  name          = "${var.hostname}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
  
  depends_on =[vsphere_virtual_machine.deploy_vm]
}

resource "vsphere_virtual_machine_snapshot" "deployed_vm" {
  virtual_machine_uuid = data.vsphere_virtual_machine.deployed_vm.id
  snapshot_name        = var.snapshot_name
  description          = var.snapshot_description
  memory               = "false"
  quiesce              = "true"
  remove_children      = "true"
  consolidate          = "true"

  depends_on =[data.vsphere_virtual_machine.deployed_vm]
}