# Traefik Dashboard

## Overview

Dashboard for monitoring Traefik ingress controller. Provides visibility into request rates, latencies, error rates, and service-level objectives (SLOs).

## Original Source

- **Dashboard ID:** 17346
- **Author:** Traefik Labs
- **Source URL:** https://grafana.com/grafana/dashboards/17346
- **License:** Apache 2.0
- **Last Updated:** 2024

**Modifications:**
- Fixed `${DS_PROMETHEUS}` → `$datasource` template variable
- Fixed all panel datasource UIDs to use `$datasource`
- Removed `__inputs` section for provisioning compatibility

## Requirements

### Metrics Required

Traefik must be configured to expose Prometheus metrics:

```yaml
# Traefik configuration
metrics:
  prometheus:
    enabled: true
    entryPoint: metrics

ports:
  metrics:
    port: 9100
    expose:
      default: false
    exposedPort: 9100
    protocol: TCP
```

### ServiceMonitor Configuration

A ServiceMonitor is required for Prometheus to scrape Traefik:

```yaml
metrics:
  prometheus:
    serviceMonitor:
      enabled: true
      labels:
        release: kube-prometheus-stack
      namespace: monitoring
      namespaceSelector:
        matchNames:
          - networking
```

### Required Metrics

- `traefik_entrypoint_open_connections` - Open connections per entrypoint
- `traefik_service_open_connections` - Open connections per service
- `traefik_entrypoint_requests_total` - Total requests per entrypoint
- `traefik_service_requests_total` - Total requests per service
- `traefik_entrypoint_request_duration_seconds` - Request duration per entrypoint
- `traefik_service_request_duration_seconds` - Request duration per service

## Features

### Core Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Request Rate | ✅ | By entrypoint and service |
| Error Rate (HTTP codes) | ✅ | Pie chart and time series by code |
| Latency (P50/P95/P99) | ✅ | Apdex score and histogram |
| Throughput | ✅ | Requests per second |
| Top Slow Services | ✅ | Ranked by response time |

### Resource Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Open Connections | ✅ | By entrypoint and service |
| CPU Usage | ❌ | TODO: Add container metrics panel |
| Memory Usage | ❌ | TODO: Add container metrics panel |

### Context & Drill-down

| Feature | Status | Notes |
|---------|--------|-------|
| Link to Logs | ❌ | TODO: Add Loki drill-down for error codes |
| Link to Traces | ❌ | TODO: Add Tempo drill-down with trace ID |
| Time Range Sync | ✅ | Uses dashboard time range |
| Service/Entrypoint Filter | ✅ | Template variables |

### SLO Monitoring

| Feature | Status | Notes |
|---------|--------|-------|
| SLO: 300ms | ✅ | Services failing 300ms threshold |
| SLO: 1200ms | ✅ | Services failing 1200ms threshold |
| Apdex Score | ✅ | Application Performance Index |

## Template Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `$datasource` | Prometheus datasource | Auto-detect |
| `$entrypoint` | Entrypoint filter | All entrypoints |
| `$service` | Service name filter | All services |

## Drill-down Configuration

### Link to Logs (TODO)

Add data links to panels for 5xx errors:

```json
{
  "links": [
    {
      "title": "View 5xx Errors in Logs",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"${datasource_logs}\",\"expr\":\"{service=~\\\"$service\\\",status=~\\\"5..\\\"}\"}]}"
    }
  ]
}
```

### Link to Traces (TODO)

Requires trace ID propagation in Traefik:

```json
{
  "links": [
    {
      "title": "View Traces",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"${datasource_traces}\",\"query\":\"service=$service\"}]}"
    }
  ]
}
```

## Known Issues

- No drill-down to logs (would require Loki integration)
- No drill-down to traces (would require Tempo integration)
- Container metrics (CPU/Memory) not included

## Future Improvements

- [ ] Add CPU/Memory panels (requires kube-state-metrics)
- [ ] Add Loki drill-down for 5xx errors
- [ ] Add Tempo drill-down for slow requests
- [ ] Add certificate expiration panel for HTTPS entrypoints
- [ ] Add alert annotations for SLO violations

## Related Dashboards

- **Cert-Manager Dashboard** - For certificate monitoring
- **Loki Dashboard** - For log correlation
- **Tempo Dashboard** - For trace correlation