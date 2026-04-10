#!/bin/bash

set -e

echo "Creating kind cluster..."

kind create cluster --name devops-lab

echo "Cluster created"

kubectl cluster-info
kubectl get nodes