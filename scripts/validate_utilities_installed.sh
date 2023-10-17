#!/bin/bash

if ! command -v minikube &> /dev/null; then
    echo "Minikube not installed"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "jq not installed"
    exit 1
fi

if ! command -v helm &> /dev/null; then
    echo "helm not installed"
    exit 1
fi

if ! command -v kubectl &> /dev/null; then
    echo "kubectl not installed"
    exit 1
fi
