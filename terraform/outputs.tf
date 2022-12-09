# output "master-ips" {
#   value = ["${proxmox_vm_qemu.proxmox_vm_masters.*.default_ipv4_address}"]
# }

# output "worker-ips" {
#   value = ["${proxmox_vm_qemu.proxmox_vm_workers.*.default_ipv4_address}"]
# }

output "master-ip" {
  value = "${proxmox_vm_qemu.proxmox_vm_master.default_ipv4_address}"
}
