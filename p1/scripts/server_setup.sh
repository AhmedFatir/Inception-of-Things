#!/bin/bash

echo "Installing K3s in controller mode..."
curl -sfL https://get.k3s.io | sh -

# Wait for K3s to be ready
sleep 10

# Copy the config file for kubectl and set permissions
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Export node token for the agent to use
cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token

echo "K3s server installation complete"
