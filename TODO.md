- wait till 14.12. for certs
- provision storage
  - local-path
  - nfs/iscsi CSI
  - nfs mounts
- figure out a backup solution
- install all dependencies only with ansible

- migration
  - mosquitto
  - zigbee2mqtt
  - plex
  - wireguard
  - gluetun for sts connection? how to expose ip for routing?
  - docker at last

- services
  - main range 10.10.0.4-10.10.0.9
  - k3s nodes on 10.10.0.200-
  - traefik lb on 10.10.0.4
  - plex on 10.10.0.5
  - mqtt on 10.10.0.6
  - site2site on 10.10.0.7
  - wireguard on 10.10.0.8

- ansible playbook for pihole
  - rpi as primary
  - vm as secondary
  - keepalived for shared ip
  - gravity sync for configuration

- https://mattei.io/vpn/2022/01/08/how-to-use-wireguard-without-masquarade.html
- https://www.procustodibus.com/blog/2020/12/wireguard-site-to-site-config/
- https://www.reddit.com/r/WireGuard/comments/sdp27b/create_route_into_wireguard_network_from_unifi/
