# DocsConverter

A Helm chart for the AssistOS Document Converter service

## Introduction

This chart deploys the DocsConverter service which is responsible for converting various document formats to be used in the AssistOS platform.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.1.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install my-release ./docsconverter
```

## Parameters

### Image parameters

| Name                 | Description                                         | Value                 |
|----------------------|-----------------------------------------------------|------------------------|
| `image.repository`   | DocsConverter image repository                      | `assistos/docsconverter` |
| `image.tag`          | DocsConverter image tag                             | `1.0.0-rc1`           |
| `image.pullPolicy`   | DocsConverter image pull policy                     | `Always`              |

### Service parameters

| Name                       | Description                                              | Value       |
|----------------------------|----------------------------------------------------------|-------------|
| `service.type`             | Service type                                             | `ClusterIP` |
| `service.port`             | Service port                                             | `3001`      |

### Persistence parameters

| Name                          | Description                             | Value         |
|-------------------------------|-----------------------------------------|---------------|
| `persistence.enabled`         | Enable persistence using PVC            | `true`        |
| `persistence.storageClassName`| PVC Storage Class name                  | `""`          |
| `persistence.accessModes`     | Persistent Volume access modes          | `[ReadWriteOnce]` |
| `persistence.size`            | PVC Storage Request size                | `10Gi`        |

### Resource parameters

| Name                          | Description                             | Value         |
|-------------------------------|-----------------------------------------|---------------|
| `resources.limits.cpu`        | CPU limit                              | `500m`        |
| `resources.limits.memory`     | Memory limit                           | `512Mi`       |
| `resources.requests.cpu`      | CPU request                            | `200m`        |
| `resources.requests.memory`   | Memory request                         | `256Mi`       |

## Configuration

The following table lists the configurable parameters of the DocsConverter chart and their default values.

```yaml
# Default values for docsconverter
replicaCount: 1

image:
  repository: assistos/docsconverter
  pullPolicy: Always
  tag: "1.0.0-rc1"

service:
  type: ClusterIP
  port: 3001

persistence:
  enabled: true
  accessModes:
    - ReadWriteOnce
  size: 10Gi
  storageClassName: ""
```

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
helm install my-release ./docsconverter --set replicaCount=2
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example:

```bash
helm install my-release ./docsconverter -f values.yaml
``` 