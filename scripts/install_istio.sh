#!/bin/bash

if ! command -v istioctl &> /dev/null; then
    echo "Istio not installed"
    exit 1
fi

CLUSTER_STATUS=$(minikube status -o json | jq -r ".Kubelet")
if [[ "${CLUSTER_STATUS}" == "Running" ]]; then
  istioctl install --skip-confirmation
else
  echo "Minikube cluster not running"
  exit 1
fi
