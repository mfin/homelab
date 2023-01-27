#!/usr/bin/env bash

DEFAULT_CLOUDFLARE_NETWORKS_FILE="${DEFAULT_CLOUDFLARE_NETWORKS_FILE:-../../k8s/networking/traefik/templates/mw-cloudflare-only.yaml}"

DATA=$(curl -s "https://api.cloudflare.com/client/v4/ips")
export CLOUDFLARE_IPS="$(echo $DATA | yq '.result.ipv4_cidrs + .result.ipv6_cidrs')"

yq -i '.spec.ipWhiteList.sourceRange |= env(CLOUDFLARE_IPS) | ..style="double"' $CLOUDFLARE_MIDDLEWARE_FILE
