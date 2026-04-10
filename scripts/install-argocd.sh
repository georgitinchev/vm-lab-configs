#!/bin/bash

set -e

echo "Installing Argo CD..."

kubectl create namespace argocd || true

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Argo CD installed successfully"