#!/bin/sh

helm template \
    --dependency-update \
    --include-crds \
    --namespace argocd \
    -f secrets://secrets.yaml \
    argocd . \
    | kubectl apply -n argocd -f -

kubectl -n argocd wait --timeout=60s --for condition=Established \
       crd/applications.argoproj.io \
       crd/applicationsets.argoproj.io
