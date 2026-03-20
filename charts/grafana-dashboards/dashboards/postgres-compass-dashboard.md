# PostgreSQL / CloudNativePG Dashboard

## Overview

Dashboard for monitoring PostgreSQL clusters managed by CloudNativePG. Provides visibility into cluster health, replication, connections, query performance, and storage.

## Original Source

- **Dashboard ID:** 20417
- **Author:** CloudNativePG Community
- **Source URL:** https://grafana.com/grafana/dashboards/20417
- **License:** Apache 2.0
- **Last Updated:** 2024

**Modifications:**
- Fixed `${DS_PROMETHEUS}` → `$datasource` template variable
- Removed `__inputs` section for provisioning compatibility
- Fixed all panel datasource UIDs

## Requirements

### Metrics Required

CloudNativePG must be configured to expose Prometheus metrics:

```yaml
# CloudNativePG cluster configuration
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: cluster-example
spec:
  monitoring:
    enablePodMonitor: true
```

### Required Metrics

- `cnpg_collector_collection_duration_seconds` - Collector duration
- `cnpg_collector_scrapes_total` - Total scrapes
- `cnpg_postgres_replication_lag` - Replication lag
- `cnpg_pg_database_size_bytes` - Database size
- `cnpg_pg_stat_database_*` - Database statistics
- `cnpg_postgres_connections` - Connection count
- `cnpg_backends_total` - Backend count

## Features

### Core Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Connection Count | ✅ | By database, user |
| Query Rate | ✅ | Transactions per second |
| Replication Status | ✅ | Primary/replica lag |
| Database Size | ✅ | Per-database storage |

### Resource Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| CPU Usage | ✅ | Container metrics |
| Memory Usage | ✅ | Container metrics |
| Storage | ✅ | Database size, WAL |
| Connection Pool | ✅ | Active/idle connections |

### Context & Drill-down

| Feature | Status | Notes |
|---------|--------|-------|
| Link to Logs | ❌ | TODO: Add Loki drill-down for errors |
| Link to Traces | ❌ | TODO: Add Tempo drill-down for slow queries |
| Time Range Sync | ✅ | Uses dashboard time range |
| Instance Filtering | ✅ | By namespace, cluster, instance |

### Operational

| Feature | Status | Notes |
|---------|--------|-------|
| Cluster Health | ✅ | Primary/replica status |
| Replication Lag | ✅ | Streaming replication delay |
| WAL Status | ✅ | WAL files and archival |
| Backup Status | ⚠️ | Partial - depends on backup configuration |
| Version Info | ✅ | PostgreSQL version |

## Template Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `$datasource` | Prometheus datasource | Auto-detect |
| `$namespace` | Kubernetes namespace | All namespaces |
| `$cluster` | PostgreSQL cluster | All clusters |
| `$instances` | Instance name | All instances |

## Drill-down Configuration

### Link to Logs (TODO)

Add data link for PostgreSQL errors:

```json
{
  "links": [
    {
      "title": "View PostgreSQL Logs",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"${datasource_logs}\",\"expr\":\"{namespace=\\\"$namespace\\\",cluster=\\\"$cluster\\\"}\",\"mode\":\"Logs\"}]}"
    }
  ]
}
```

### Link to Traces (TODO)

For applications using PostgreSQL:

```json
{
  "links": [
    {
      "title": "View Database Traces",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"${datasource_traces}\",\"query\":\"db.type=\\\"postgresql\\\"\"}]}"
    }
  ]
}
```

## Known Issues

- Slow query logs require additional configuration
- No automatic drill-down to application traces
- Backup status depends on backup solution used

## Future Improvements

- [ ] Add Loki drill-down for PostgreSQL errors
- [ ] Add slow query correlation with application traces
- [ ] Add connection pool saturation alerts
- [ ] Add PGO (PostgreSQL Operator) specific metrics
- [ ] Add database bloat analysis panels

## Related Dashboards

- **Loki Dashboard** - For PostgreSQL log correlation
- **Application Dashboard** - For trace correlation with database queries
- **Redis Dashboard** - For cache comparison metrics