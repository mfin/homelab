resource "unifi_static_route" "site-to-site" {
  type     = "nexthop-route"
  network  = data.sops_file.secrets.data["static_route.destination"]
  name     = "site-to-site route"
  distance = 1
  next_hop = data.sops_file.secrets.data["static_route.next_hop"]
}
