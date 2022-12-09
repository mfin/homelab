.POSIX:

default: terraform ansible k8s

terraform:
	cd terraform && terraform init && terraform apply -auto-approve

.PHONY: ansible
ansible:
	cd ansible && ansible-playbook -i ./inventory/homelab/hosts.ini ./k3s.yml

.PHONY: k8s
k8s:
	cd k8s/bootstrap && make
