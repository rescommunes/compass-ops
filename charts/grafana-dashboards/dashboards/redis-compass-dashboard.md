# Redis Dashboard

## Overview

Dashboard for monitoring Redis instances. Provides visibility into memory usage, connections, command rates, and key statistics.

## Original Source

- **Dashboard ID:** 14091
- **Author:** Redis Exporter Community
- **Source URL:** https://grafana.com/grafana/dashboards/14091
- **License:** Apache 2.0
- **Last Updated:** 2024

**Modifications:**
- Removed `__inputs` section for provisioning compatibility
- Uses `$datasource` template variable for Prometheus selection

## Requirements

### Metrics Required

Redis Exporter must be deployed alongside your Redis instance:

```yaml
# Redis deployment with exporter sidecar
containers:
  - name: redis
    image: redis:7
    ...
  - name: redis-exporter
    image: redis/redis-exporter:latest
    ports:
      - name: metrics
        containerPort: 9121
```

### ServiceMonitor Configuration

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: redis-exporter
spec:
  selector:
    matchLabels:
      app: redis
  endpoints:
    - port: metrics
      path: /metrics
```

### Required Metrics

- `redis_up` - Redis instance status
- `redis_connected_clients` - Connected clients count
- `redis_memory_used_bytes` - Memory usage
- `redis_commands_processed_total` - Total commands processed
- `redis_keyspace_hits_total` - Keyspace hits
- `redis_keyspace_misses_total` - Keyspace misses
- `redis_expired_keys_total` - Expired keys count
- `redis_evicted_keys_total` - Evicted keys count

## Features

### Core Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Request Rate | ✅ | Commands executed per second |
| Hit/Miss Rate | ✅ | Keyspace hit/miss ratio |
| Memory Usage | ✅ | Total memory consumption |
| Connection Count | ✅ | Connected clients |

### Resource Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Memory Usage | ✅ | Total and per-db memory |
| Network I/O | ✅ | Bytes in/out |
| CPU Usage | ❌ | TODO: Add container metrics |
| Connection Pool | ✅ | Connected clients graph |

### Context & Drill-down

| Feature | Status | Notes |
|---------|--------|-------|
| Link to Logs | ❌ | TODO: Add Loki drill-down for errors |
| Link to Traces | N/A | Redis doesn't produce traces |
| Time Range Sync | ✅ | Uses dashboard time range |
| Instance Filtering | ✅ | By namespace, pod, instance |

### Operational

| Feature | Status | Notes |
|---------|--------|-------|
| Uptime Status | ✅ | Shows Redis uptime |
| Key Statistics | ✅ | Total items per DB |
| Expiring Keys | ✅ | Expiring vs non-expiring |
| Evicted Keys | ✅ | Expired/evicted rate |

## Template Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `$datasource` | Prometheus datasource | Auto-detect |
| `$namespace` | Kubernetes namespace | All namespaces |
| `$pod_name` | Redis pod name | All pods |
| `$instance` | Redis instance address | All instances |

## Drill-down Configuration

### Link to Logs (TODO)

Add data link for Redis errors:

```json
{
  "links": [
    {
      "title": "View Redis Logs",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"${datasource_logs}\",\"expr\":\"{pod=\\\"$pod_name\\\"}\",\"mode\":\"Logs\"}]}"
    }
  ]
}
```

## Known Issues

- Container CPU/Memory metrics not included
- No drill-down to logs for error investigation
- Single instance view only (no cluster status)

## Future Improvements

- [ ] Add CPU/Memory panels from kube-state-metrics
- [ ] Add Redis Cluster status panels
- [ ] Add Loki drill-down for connection errors
- [ ] Add alert annotations for memory thresholds
- [ ] Add replication status for Redis replicas

## Related Dashboards

- **Loki Dashboard** - For Redis log correlation
- **PostgreSQL Dashboard** - For database comparison metrics