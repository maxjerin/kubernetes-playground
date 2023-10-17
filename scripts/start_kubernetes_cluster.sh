#!/bin/bash

if ! command -v minikube &> /dev/null; then
    echo "Minikube not installed"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "jq not installed"
    exit 1
fi

CLUSTER_STATUS=$(minikube status -o json | jq -r ".Kubelet")
if [[ "${CLUSTER_STATUS}" != "Running" ]]; then
  echo "Minikube cluster not running"
  echo "Starting cluster"
  minikube start
  exit 1
fi
