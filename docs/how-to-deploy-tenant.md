# How to Deploy a MinIO Tenant

This guide explains how to deploy a MinIO tenant using the MinIO Operator and Helm in a Kubernetes cluster, using the provided `itlminio01.yaml` configuration as an example.



## Prerequisites

- A running Kubernetes cluster (v1.21+ recommended)
- `kubectl` installed and configured
- [MinIO Operator](https://github.com/minio/operator) installed in your cluster
- [Helm](https://helm.sh/) installed
- Proper storage class and persistent volume support in your cluster

## 1. Prepare Your Values File

Use the provided `itlminio01.yaml` as your values file. This file configures a tenant named `itlminio01` with the following key settings:

- **MinIO Image:** Uses `quay.io/minio/minio:RELEASE.2025-05-24T17-08-30Z`
- **Storage:** 4 servers, each with 2 volumes of 5Gi, using the `ha-dbs-lh` storage class
- **Security:** Runs as non-root with strict security context
- **Ingress:** Both API and Console endpoints are exposed with Traefik and TLS, using Let's Encrypt for certificates
- **Console:** Accessible at `https://itlminio01-console.dev.itlusions.com/`
- **API:** Accessible at `https://itlminio01.dev.itlusions.com/`
- **Other:** Metrics are disabled by default, and advanced features like SFTP and bucket DNS are off

You can further customize this file as needed for your environment.

## 2. Deploy the Tenant with Helm

Run the following command to deploy the tenant using your customized values file:

```sh
helm upgrade --install itlminio01 ./chart -n minio-operator --create-namespace -f itlminio01.yaml
```

- Replace `./chart` with the path to your MinIO Tenant Helm chart.
- The namespace `minio-operator` should match where the operator is installed.

## 3. Verify the Deployment

Check the status of your tenant pods:

```sh
kubectl get pods -n minio-operator -l v1.min.io/tenant=itlminio01
```

Check the tenant resource:

```sh
kubectl get tenants -n minio-operator
```

## 4. Access the MinIO Console and API

Once the pods are running and ingress is configured, access the MinIO Console at [https://itlminio01-console.dev.itlusions.com/](https://itlminio01-console.dev.itlusions.com/) and the API at [https://itlminio01.dev.itlusions.com/](https://itlminio01.dev.itlusions.com/).

Login using the credentials set in your `configSecret` section of `itlminio01.yaml`.

## 5. (Optional) Enable Additional Features

To enable features such as OpenID Connect, SFTP, or custom buckets/users, edit the relevant sections in your `itlminio01.yaml` and redeploy with Helm.

## Redundancy in MinIO: Application and Storage Layers

MinIO is designed for high availability and data durability through redundancy at both the application and storage layers:

- **Application Layer Redundancy:**  
  The deployment uses 4 MinIO server pods (instances). These pods work together in a distributed mode, so if one pod fails, the others continue to serve requests without downtime. This ensures that the MinIO service remains available even if some pods are temporarily unavailable.

- **Storage Layer Redundancy:**  
  Each server pod is configured with 2 persistent volumes (totaling 8 volumes). MinIO automatically erasure-codes data across all these volumes. This means that even if one or more volumes (or the underlying disks) fail, your data remains accessible and protected against loss. The erasure coding scheme provides both fault tolerance and efficient storage utilization.

This dual-layer redundancy helps ensure both high availability and strong data protection for your object storage workloads.

---

**Tip:**  
Always review the [MinIO Operator documentation](https://min.io/docs/minio/kubernetes/upstream/index.html) for advanced configuration and troubleshooting.

**Niels Weistra** at **n.weistra@itlusions.com**.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?logo=linkedin&logoColor=white)](https://nl.linkedin.com/in/nielswei)