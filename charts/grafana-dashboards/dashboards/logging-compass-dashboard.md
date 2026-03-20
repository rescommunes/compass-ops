# Logging Dashboard

## Overview

Dashboard for exploring logs across all Kubernetes namespaces using Loki. Provides log volume visualization, error detection, and log exploration capabilities.

## Original Source

- **Dashboard ID:** Custom
- **Author:** Based on Loki best practices
- **Source URL:** N/A (custom)
- **License:** Apache 2.0
- **Last Updated:** 2024

**Modifications:**
- Created from scratch for generic Kubernetes logging
- Uses `$datasource_logs` template variable for Loki datasource selection
- Supports namespace and pod filtering

## Requirements

### Metrics Required

Loki must be deployed with Promtail collecting logs:

```yaml
# Promtail configuration
promtail:
  config:
    clients:
      - url: http://loki:3100/loki/api/v1/push
    snippets:
      pipelineStages:
        - docker: {}
      k8sHostname: true
```

### Required Labels

Logs must include Kubernetes labels:
- `namespace` - Kubernetes namespace
- `k8s_pod_name` or `pod` - Pod name
- `app` or `service` - Application/service name (optional)

## Features

### Core Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Log Volume by Namespace | ✅ | Stacked bar chart over time |
| Error Detection | ✅ | Regex filter for errors |
| Log Explorer | ✅ | Full-text search with filters |

### Resource Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Namespace Filtering | ✅ | Multi-select |
| Pod Filtering | ✅ | Multi-select |
| Time Range Selection | ✅ | Dashboard time range |

### Context & Drill-down

| Feature | Status | Notes |
|---------|--------|-------|
| Link to Logs | ✅ | Native Loki logs panel |
| Link to Traces | ⚠️ | Requires trace ID in logs |
| Time Range Sync | ✅ | Uses dashboard time range |
| Namespace Filtering | ✅ | Template variable |

### Operational

| Feature | Status | Notes |
|---------|--------|-------|
| Error Highlighting | ✅ | Regex filter for errors |
| Log Deduplication | ❌ | TODO: Add dedup option |
| Log Context | ⚠️ | Show surrounding lines (needs config) |

## Template Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `$datasource_logs` | Loki datasource | Auto-detect |
| `$namespace` | Kubernetes namespace filter | All namespaces |
| `$pod` | Pod name filter | All pods |

## Drill-down Configuration

### Error Detection

The "Recent Errors" panel uses regex to find errors:

```logql
{namespace=~"$namespace"} |~ "(?i)error|err|fatal|critical"
```

### Log Explorer

Full log exploration with namespace and pod filtering:

```logql
{namespace=~"$namespace", k8s_pod_name=~"$pod"}
```

## Known Issues

- High cardinality namespaces may cause query performance issues
- No persistent log context (surrounding lines)
- No automatic trace correlation

## Future Improvements

- [ ] Add log deduplication option
- [ ] Add trace ID correlation with Tempo
- [ ] Add alert annotations for error spikes
- [ ] Add multi-line log support
- [ ] Add JSON log parsing panels
- [ ] Add service-level log volume breakdown

## Related Dashboards

- **Loki Dashboard** - For Loki infrastructure metrics
- **Traefik Dashboard** - For ingress log correlation
- **Tempo Dashboard** - For trace correlation (requires trace ID in logs)