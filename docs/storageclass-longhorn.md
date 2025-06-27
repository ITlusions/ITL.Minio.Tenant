# Longhorn StorageClass for Kubernetes

This document provides a sample YAML manifest and explanation for creating a Kubernetes `StorageClass` using [Longhorn](https://longhorn.io/) as the storage backend. This configuration is suitable for workloads that require high availability and persistent storage.

## Storage Layer Redundancy in Longhorn

Longhorn achieves storage layer redundancy by replicating data across multiple nodes in your Kubernetes cluster. The `numberOfReplicas` parameter in the StorageClass defines how many copies of each volume are maintained. For example, setting `numberOfReplicas: "3"` ensures that three copies of your data are stored on different nodes. This design provides high availability and fault tolerance—if a node fails, your data remains accessible from the remaining replicas. Longhorn automatically manages replica synchronization and recovery to maintain the desired redundancy level.

## StorageClass YAML Example

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  # Naming convention: <ha/basic>-<dbs/dos>-<lh/ebs>
  name: ha-dbs-lh
provisioner: driver.longhorn.io
parameters:
  numberOfReplicas: "3"             # Number of data replicas for high availability
  staleReplicaTimeout: "30"         # Seconds before a replica is considered stale
reclaimPolicy: Retain               # Retain or Delete the volume after PVC deletion
allowVolumeExpansion: true          # Allow resizing of PersistentVolumeClaims
volumeBindingMode: Immediate        # Or WaitForFirstConsumer
```

## Field Descriptions

- **apiVersion**: API version for the StorageClass resource.
- **kind**: Resource type, always `StorageClass`.
- **metadata.name**: Name of the StorageClass. Use a descriptive convention, e.g., `ha-dbs-lh`.
- **provisioner**: Specifies the Longhorn CSI driver (`driver.longhorn.io`).
- **parameters**:
  - `numberOfReplicas`: Number of data replicas for redundancy (e.g., `"3"` for triple replication).
  - `staleReplicaTimeout`: Time in seconds before a replica is considered stale and eligible for removal.
- **reclaimPolicy**: What happens to a PersistentVolume after its claim is deleted. `Retain` keeps the volume for manual cleanup; `Delete` removes it automatically.
- **allowVolumeExpansion**: Enables resizing of PersistentVolumeClaims created from this StorageClass.
- **volumeBindingMode**: Controls when volume binding and provisioning occurs. `Immediate` binds as soon as the PVC is created; `WaitForFirstConsumer` waits until a pod is scheduled.

## Usage

Apply the manifest to your Kubernetes cluster:

```sh
kubectl apply -f storageclass-longhorn.yaml
```

You can then reference this StorageClass in your PersistentVolumeClaims to provision Longhorn-backed volumes with high availability.
