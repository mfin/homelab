#!/usr/bin/env bash

DATA=$(curl -s "https://api.cloudflare.com/client/v4/ips")
export CLOUDFLARE_IPS="$(echo $DATA | yq '.result.ipv4_cidrs + .result.ipv6_cidrs')"

yq -i '.spec.ipWhiteList.sourceRange |= env(CLOUDFLARE_IPS) | ..style="double"' $1
yq -i '.spec.ipWhiteList.sourceRange += ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"] | ..style="double"' $1
