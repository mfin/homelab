resource "unifi_port_forward" "plex" {
  name     = "plex"
  dst_port = 32400
  fwd_ip   = data.sops_file.secrets.data["forward.plex.ip"]
  fwd_port = 32400
  protocol = "tcp"

  port_forward_interface = "wan"
}
