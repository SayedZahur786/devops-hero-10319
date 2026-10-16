# Kubernetes volumes

- emptyDir lasts for the lifetime of a Pod and is shared by its containers.
- hostPath exposes a path on the node and ties the Pod to node-local data.
- A PersistentVolume is storage capacity; a PersistentVolumeClaim requests it.
- A StorageClass names a provisioner and its policy. Dynamic provisioning creates suitable storage for a PVC when the provisioner is available.

These are notes only. No storage mini-project is claimed in this rebuild.
