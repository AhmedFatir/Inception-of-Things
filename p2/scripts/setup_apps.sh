#!/bin/bash

# Directory where manifest files are stored
MANIFESTS_DIR="/vagrant/confs/k3s-apps/manifests"

# Function to display error messages
error_handler() {
  echo "ERROR: [SERVER] $1"
  exit 1
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
  error_handler "kubectl is not installed or not in PATH"
fi

echo "[SERVER] Deploying applications to K3s..."

# Apply all Kubernetes manifests
kubectl apply -f "$MANIFESTS_DIR/app1.yaml" || error_handler "Failed to deploy app1"
kubectl apply -f "$MANIFESTS_DIR/app2.yaml" || error_handler "Failed to deploy app2"
kubectl apply -f "$MANIFESTS_DIR/app3.yaml" || error_handler "Failed to deploy app3"
kubectl apply -f "$MANIFESTS_DIR/ingress.yaml" || error_handler "Failed to create ingress"

# Wait for deployments to be ready
echo "[SERVER] Waiting for deployments to be ready..."
kubectl rollout status deployment/app-one --timeout=60s || error_handler "App1 deployment failed"
kubectl rollout status deployment/app-two --timeout=60s || error_handler "App2 deployment failed"
kubectl rollout status deployment/app-three --timeout=60s || error_handler "App3 deployment failed"

echo "[SERVER] All applications have been deployed successfully!"
