resource "unifi_port_forward" "https" {
  name     = "https"
  dst_port = 443
  fwd_ip   = data.sops_file.secrets.data["forward.https.ip"]
  fwd_port = 443
  protocol = "tcp"

  port_forward_interface = "wan"
}

resource "unifi_port_forward" "plex" {
  name     = "plex"
  dst_port = 32400
  fwd_ip   = data.sops_file.secrets.data["forward.plex.ip"]
  fwd_port = 32400
  protocol = "tcp"

  port_forward_interface = "wan"
}
