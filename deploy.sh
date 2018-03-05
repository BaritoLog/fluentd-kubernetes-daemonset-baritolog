#!/bin/sh

docker build -t fluentd-kubernetes-daemonset:baritolog docker-image/v0.12/debian-baritolog
kubectl delete ds fluentd-daemonset-baritolog --namespace=kube-system
kubectl apply -f fluentd-daemonset-baritolog.yaml