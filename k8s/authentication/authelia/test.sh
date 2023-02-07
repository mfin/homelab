if [[ $(kubectl get -n argocd application whoami -o json | jq '.spec.syncPolicy == null') == "true" ]]; then
  exit 0
else
  exit 1
fi
