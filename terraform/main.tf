resource "proxmox_vm_qemu" "proxmox_vm_master" {
  name  = "k3s-master-1"
  desc  = "K3S Master Node"
  vmid = 301

  ipconfig0   = "gw=10.10.0.1,ip=10.10.0.301/24"
  ipconfig1   = "ip=10.3.0.301/24"

  target_node = "pve"
  onboot      = true
  clone      = "ubuntu-20221207"
  full_clone = false
  os_type    = "cloud-init"
  agent      = 1
  memory     = 1024
  cores      = 1
  nameserver = "10.10.0.3"
  hastate = "ignored"
  iothread = 0
 
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }

#   lifecycle {
#     ignore_changes = [
#       network, disk, sshkeys, target_node
#     ]
#   }
}

# resource "proxmox_vm_qemu" "proxmox_vm_workers" {
#   count = var.num_k3s_nodes
#   name  = "k3s-worker-${count.index}"
#   ipconfig0   = "gw=${var.k3s_gateway},ip=${var.k3s_worker_ip_addresses[count.index]}"
#   target_node = var.k3s_worker_pve_node[count.index]
#   onboot      = true
#   hastate     = "started"
#   # Same CPU as the Physical host, possible to add cpu flags
#   # Ex: "host,flags=+md-clear;+pcid;+spec-ctrl;+ssbd;+pdpe1gb"
#   cpu   = "host"
#   numa  = false
#   clone = "${var.template_vm_name}-${var.k3s_worker_pve_node[count.index]}"
#   os_type    = "cloud-init"
#   agent      = 1
#   ciuser     = var.k3s_user
#   memory     = var.num_k3s_node_mem
#   cores      = var.k3s_node_cores
#   nameserver = var.k3s_nameserver

#   network {
#     model  = "virtio"
#     bridge = "vmbr0"
#     tag    = var.k3s_vlan
#   }

#   serial {
#     id   = 0
#     type = "socket"
#   }

#   vga {
#     type = "serial0"
#   }

#   disk {
#     size    = var.k3s_node_root_disk_size
#     storage = var.k3s_node_disk_storage
#     type    = "scsi"
#     format  = "qcow2"
#     backup  = 1
#   }

#   disk {
#     size    = var.k3s_node_data_disk_size
#     storage = var.k3s_node_disk_storage
#     type    = "scsi"
#     format  = "qcow2"
#     backup  = 1
#   }

#   lifecycle {
#     ignore_changes = [
#       network, disk, sshkeys, target_node
#     ]
#   }
# }

# data "template_file" "k3s" {
#   template = file("./templates/k3s.tpl")
#   vars = {
#     k3s_master_ip = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_master : join("", [instance.name, " ansible_host=", instance.default_ipv4_address])])}"
#     k3s_node_ip   = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_workers : join("", [instance.name, " ansible_host=", instance.default_ipv4_address])])}"
#   }
# }

# resource "local_file" "k3s_file" {
#   content  = data.template_file.k3s.rendered
#   filename = "../../inventory/k3s"
# }
