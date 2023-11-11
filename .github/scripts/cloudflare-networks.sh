#!/usr/bin/env bash

DATA=$(curl -s "https://api.cloudflare.com/client/v4/ips")
export WHITELIST_IPS="$(echo $DATA | yq '.result.ipv4_cidrs + .result.ipv6_cidrs + ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"] | join(",")' -)"

yq -i '.ingress-nginx.controller.config.whitelist-source-range = env(WHITELIST_IPS)' $1
