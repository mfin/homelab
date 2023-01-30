.POSIX:

default: k3s-ansible k8s

.PHONY: k3s-ansible
k3s-ansible:
	cd ansible/k3s && ansible-playbook -i ./inventory/homelab/hosts.ini ./k3s.yml

.PHONY: k8s
k8s:
	cd k8s/bootstrap && make
