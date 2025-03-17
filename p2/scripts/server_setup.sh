#!/bin/bash
error_handler() {
  echo "ERROR: [SERVER] $1"
  echo "Executing..."
  exit 1
}

echo "[SERVER] Installing dependencies..."
apt-get update > /dev/null 2>&1 || error_handler "Failed to update packages"
apt-get upgrade -y > /dev/null 2>&1 || error_handler "Failed to upgrade packages"
apt-get install -y curl > /dev/null 2>&1 || error_handler "Failed to install dependencies"

echo "[SERVER] Installing K3s in controller mode..."
curl -sfL https://get.k3s.io | \
INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1 --tls-san=192.168.56.110" sh - > /dev/null 2>&1 \
|| error_handler "Failed to install K3s"

echo "[SERVER] Waiting for K3s to start..."
sleep 10

# Verify K3s is running
systemctl is-active --quiet k3s || error_handler "K3s service is not running"

echo "[SERVER] Configuring kubectl for vagrant user..."
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sed -i 's/127.0.0.1/192.168.56.110/g' /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo "[SERVER] Setting up environment..."
echo "export KUBECONFIG=/home/vagrant/.kube/config
export PATH=\$PATH:/usr/local/bin
alias k='kubectl'" >> /home/vagrant/.bashrc

echo "[SERVER] Copying kubeconfig to shared directory..."
mkdir -p /vagrant/confs
cat /home/vagrant/.kube/config > "/vagrant/confs/kubeconfig"

echo "[SERVER] Verifying cluster status..."
kubectl get nodes > /dev/null 2>&1 || error_handler "Failed to get nodes"

echo "[SERVER] K3s server installation complete."
