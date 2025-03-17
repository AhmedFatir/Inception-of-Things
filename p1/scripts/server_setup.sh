#!/bin/bash

echo "Installing dependencies on server node..."
apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
apt-get install -y curl > /dev/null 2>&1

echo "Installing K3s in controller mode..."
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1" sh - > /dev/null 2>&1

echo "Waiting for K3s to start..."
sleep 10

echo "Copying kubeconfig to vagrant user..."
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo "Setting up kubectl..."
echo 'export KUBECONFIG=/home/vagrant/.kube/config' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:/usr/local/bin' >> /home/vagrant/.bashrc
echo 'alias k="kubectl"' >> /home/vagrant/.bashrc

echo "Copying node token to shared folder..."
cat /var/lib/rancher/k3s/server/node-token > /vagrant/confs/node-token

echo "K3s server installation complete"
