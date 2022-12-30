.POSIX:

default: namespace argocd app-of-apps

namespace:
	kubectl create namespace argocd --dry-run=client --output=yaml \
		| kubectl apply -f -

.PHONY: argocd
argocd:
	cd argocd && ./apply.sh

.PHONY: app-of-apps
app-of-apps:
	cd app-of-apps && ./apply.sh
