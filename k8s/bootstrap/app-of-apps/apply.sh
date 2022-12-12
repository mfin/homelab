#!/bin/sh

helm template \
    --include-crds \
    --namespace argocd \
    --values values.yaml \
    app-of-apps . \
    | kubectl apply -n argocd -f -
