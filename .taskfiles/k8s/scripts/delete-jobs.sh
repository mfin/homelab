#!/bin/bash

JOB_LIST=$(kubectl get jobs --all-namespaces --template '{{range .items}}{{.metadata.namespace}},{{.metadata.name}}{{"\n"}}{{end}}')

for j in $JOB_LIST
do
    str=$(echo $j | tr "," " ")
    kubectl delete job -n $str
done
