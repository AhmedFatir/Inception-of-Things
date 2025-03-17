#!/bin/bash
set -euo pipefail

echo "Installing dependencies on agent node..."
apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
apt-get install -y curl > /dev/null 2>&1

# Correct the waiting loop to use the proper path where node-token is copied
while [ ! -f "/vagrant/confs/node-token" ]; do
  echo "Waiting for node token..."
  sleep 3
done

echo "Get the Node token, from the file shared by server..."
NODE_TOKEN=$(cat "/vagrant/confs/node-token")

echo "Installing K3s in agent mode..."
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN="${NODE_TOKEN}" INSTALL_K3S_EXEC="--node-ip=192.168.56.111 --flannel-iface=eth1" sh - > /dev/null 2>&1

echo "K3s agent installation complete"
