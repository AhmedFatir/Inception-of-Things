# K3s Multiple Web Applications with Host-Based Routing

This project sets up three web applications in a K3s Kubernetes cluster with host-based routing.

## Overview

The setup includes:
- Three simple web applications using Nginx
- Kubernetes Deployments and Services for each app
- Ingress controller configuration for host-based routing
- app1.com routes to App 1
- app2.com routes to App 2
- Any other host (default) routes to App 3

## Installation

To run the manifests

```bash
kubectl apply -Rf ./manifests
```
To delete all the resource
```bash
kubectl delete -Rf ./manifests
```


## Accessing Applications

- **Path-based routing:**
    - **App1**: http://192.168.56.110/app1
    - **App2**: http://192.168.56.110/app2
    - **App3**: http://192.168.56.110

- **Host-based routing:**
```bash
# For App 1
curl -H "Host: app1.com" http://192.168.56.110

# For App 2
curl -H "Host: app2.com" http://192.168.56.110

# For App 3 (default)
curl http://192.168.56.110
```