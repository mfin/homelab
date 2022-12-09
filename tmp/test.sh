ARGOCD_ENVSUBST_PLUGIN_SECRET_NAME=argocd-envsubst
ARGOCD_ENVSUBST_PLUGIN_NAMESPACE_NAME=argocd

export $(kubectl get secret -n $ARGOCD_ENVSUBST_PLUGIN_NAMESPACE_NAME $ARGOCD_ENVSUBST_PLUGIN_SECRET_NAME -o json | jq -r '.data | to_entries | map("\(.key)=\(.value|@base64d)") | .[]')

#envsubst < test.yaml

# helm template --release-name "$ARGOCD_APP_NAME" | envsubst
