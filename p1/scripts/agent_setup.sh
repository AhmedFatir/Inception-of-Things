#!/bin/bash
error_handler() {
  echo "ERROR: [AGENT] $1"
  echo "Executing..."
  exit 1
}

echo "[AGENT] Installing dependencies..."
apt-get update > /dev/null 2>&1 || error_handler "Failed to update packages"
apt-get upgrade -y > /dev/null 2>&1 || error_handler "Failed to upgrade packages"
apt-get install -y curl > /dev/null 2>&1 || error_handler "Failed to install dependencies"

echo "[AGENT] Waiting for node token (max 2 minutes)..."
TIMEOUT=120
COUNTER=0
while [ ! -f "/vagrant/confs/node-token" ] && [ $COUNTER -lt $TIMEOUT ]; do
  echo "[AGENT] Waiting for node token... ($COUNTER/$TIMEOUT seconds)"
  sleep 3
  COUNTER=$((COUNTER+3))
done

if [ ! -f "/vagrant/confs/node-token" ]; then
  error_handler "Timed out waiting for node token."
fi

echo "[AGENT] Node token found, proceeding with installation..."
NODE_TOKEN=$(cat "/vagrant/confs/node-token")

echo "[AGENT] Installing K3s in agent mode..."
curl -sfL https://get.k3s.io | \
K3S_URL=https://192.168.56.110:6443 \
K3S_TOKEN="${NODE_TOKEN}" \
INSTALL_K3S_EXEC="--node-ip=192.168.56.111 --flannel-iface=eth1" sh - > /dev/null 2>&1 \
|| error_handler "Failed to install K3s"

echo "[AGENT] Verifying K3s agent is running..."
systemctl is-active --quiet k3s-agent || error_handler "K3s agent service is not running"

echo "[AGENT] Waiting for registration with master..."
sleep 5

echo "[AGENT] K3s agent installation complete."
