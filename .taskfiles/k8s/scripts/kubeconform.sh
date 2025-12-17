#!/usr/bin/env bash

set -euo pipefail

namespace=$1
app=$2

# renovate: datasource=github-releases depName=kubernetes/kubernetes
kubernetes_version="v1.35.0"

schema_location="https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json"

# schema-location default is https://github.com/yannh/kubernetes-json-schema
namespace=$namespace app=$app task k:template | kubeconform -strict -kubernetes-version $(echo $kubernetes_version | sed 's/v//') -skip CustomResourceDefinition -schema-location default -schema-location "$schema_location"
