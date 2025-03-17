#!/bin/bash

echo "Installing K3s in agent mode..."

# Wait for the server token to be available
while [ ! -f /vagrant/node-token ]; do
  echo "Waiting for node token..."
  sleep 5
done

# Get the token from the file shared by server
NODE_TOKEN=$(cat /vagrant/node-token)

# Install K3s agent
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=${NODE_TOKEN} sh -

# Set up kubectl configuration
mkdir -p /home/vagrant/.kube

echo "K3s agent installation complete"
