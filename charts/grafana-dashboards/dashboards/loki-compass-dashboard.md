# Loki / Promtail Dashboard

## Overview

Dashboard for monitoring the Loki logging stack including Promtail collectors. Provides visibility into log ingestion rates, pipeline performance, and storage metrics.

## Original Source

- **Dashboard ID:** 14055
- **Author:** Grafana Community
- **Source URL:** https://grafana.com/grafana/dashboards/14055
- **License:** Apache 2.0
- **Last Updated:** 2024

**Modifications:**
- Fixed `${DS_PROMETHEUS}` and `${DS_LOKI}` template variables
- Removed `__inputs` section for provisioning compatibility
- Added `$datasource` variable for Prometheus
- Added `$datasource_logs` variable for Loki (TODO - needs configuration)

## Requirements

### Metrics Required

Loki must be configured to expose metrics:

```yaml
# Loki configuration
loki:
  structuredConfig:
    limits_config:
      metric_aggregation_enabled: true
```

Promtail must be configured:

```yaml
# Promtail configuration
promtail:
  config:
    clients:
      - url: http://loki:3100/loki/api/v1/push
```

### Required Metrics

- `loki_ingester_bytes_received_total` - Bytes received
- `loki_ingester_entries_total` - Log entries received
- `loki_distributor_lines_received_total` - Lines received by distributor
- `loki_query_request_duration_seconds` - Query latency
- `promtail_tail_bytes_read_total` - Promtail bytes read
- `promtail_tail_lines_read_total` - Promtail lines read

## Features

### Core Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Log Ingestion Rate | ✅ | Bytes and entries per second |
| Query Latency | ✅ | Request duration histogram |
| Active Streams | ✅ | Stream count and rate |
| Pipeline Metrics | ✅ | Promtail pipeline stats |

### Resource Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Ingestion Volume | ✅ | Bytes received |
| Storage | ✅ | Chunk and index sizes |
| CPU/Memory | ❌ | TODO: Add container metrics |
| Network I/O | ✅ | Bytes transferred |

### Context & Drill-down

| Feature | Status | Notes |
|---------|--------|-------|
| Link to Logs | ✅ | Loki Explore integration |
| Link to Traces | ⚠️ | Requires trace ID correlation |
| Time Range Sync | ✅ | Uses dashboard time range |
| Service Filtering | ❌ | TODO: Add namespace/service variables |

### Operational

| Feature | Status | Notes |
|---------|--------|-------|
| Ingestion Health | ✅ | Rate and volume tracking |
| Query Performance | ✅ | Latency percentiles |
| Retention Status | ✅ | Chunk and index info |
| Pipeline Errors | ✅ | Promtail error tracking |

## Template Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `$datasource` | Prometheus datasource | Auto-detect |
| `$datasource_logs` | Loki datasource | Auto-detect (requires config) |

## Drill-down Configuration

### Link to Logs

The dashboard includes panels that drill down to Loki logs:

```json
{
  "links": [
    {
      "title": "View Logs",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"$datasource_logs\",\"expr\":\"rate({job=\\\"promtail\\\"}[5m])\"}]}"
    }
  ]
}
```

## Known Issues

- Requires Loki datasource to be configured separately
- No cross-namespace filtering
- No trace correlation (requires tempo datasource)

## Future Improvements

- [ ] Add Loki-specific queries for log volume per namespace
- [ ] Add container CPU/Memory metrics for Promtail and Loki
- [ ] Add trace-to-logs correlation with Tempo
- [ ] Add alert annotations for ingestion rate limits
- [ ] Add retention policy visibility

## Related Dashboards

- **Tempo Dashboard** - For trace correlation
- **OpenTelemetry Collector Dashboard** - For pipeline correlation
- **Traefik Dashboard** - For ingress log correlation