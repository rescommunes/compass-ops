# OpenTelemetry Collector Dashboard

## Overview

Dashboard for monitoring OpenTelemetry Collector instances. Provides visibility into receiver, processor, and exporter metrics including throughput, latency, and error rates.

## Original Source

- **Dashboard ID:** 12553
- **Author:** OpenTelemetry Community
- **Source URL:** https://grafana.com/grafana/dashboards/12553
- **License:** Apache 2.0
- **Last Updated:** 2024

**Modifications:**
- Added `$datasource` template variable for Prometheus
- Removed `__inputs` section for provisioning compatibility
- Fixed all panel datasource UIDs

## Requirements

### Metrics Required

OpenTelemetry Collector must expose Prometheus metrics:

```yaml
# OpenTelemetry Collector configuration
apiVersion: opentelemetry.io/v1beta1
kind: OpenTelemetryCollector
spec:
  config:
    service:
      telemetry:
        metrics:
          level: detailed
          address: 0.0.0.0:8888
    receivers:
      - otlp
    processors:
      - batch
    exporters:
      - otlp
```

### ServiceMonitor Configuration

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: otel-collector
spec:
  selector:
    matchLabels:
      app: otel-collector
  endpoints:
    - port: metrics
      path: /metrics
```

### Required Metrics

- `otelcol_receiver_accepted_metric_points` - Metrics accepted by receivers
- `otelcol_receiver_accepted_spans` - Spans accepted by receivers
- `otelcol_processor_batch_batch_size` - Batch processor metrics
- `otelcol_exporter_sent_metric_points` - Metrics sent by exporters
- `otelcol_exporter_sent_spans` - Spans sent by exporters
- `otelcol_process_cpu_seconds` - CPU usage
- `otelcol_process_memory_rss` - Memory usage

## Features

### Core Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Receive Rate | ✅ | Metric points and spans per second |
| Export Rate | ✅ | Throughput by exporter type |
| Queue Size | ✅ | Pending items by processor |
| Error Rate | ✅ | Failed sends by receiver/exporter |

### Resource Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| CPU Usage | ✅ | Process CPU seconds |
| Memory Usage | ✅ | RSS memory |
| Goroutines | ✅ | Active goroutines count |
| Pipeline Latency | ✅ | Processing time histogram |

### Context & Drill-down

| Feature | Status | Notes |
|---------|--------|-------|
| Link to Logs | ❌ | TODO: Add Loki drill-down for errors |
| Link to Traces | ⚠️ | Collector traces available via OTLP |
| Time Range Sync | ✅ | Uses dashboard time range |
| Pipeline Filtering | ✅ | Filter by receiver/processor/exporter |

### Operational

| Feature | Status | Notes |
|---------|--------|-------|
| Pipeline Status | ✅ | Per-component health |
| Throughput | ✅ | Items per second by pipeline |
| Error Tracking | ✅ | Failed items by component |
| Version Info | ✅ | Collector version |

## Template Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `$datasource` | Prometheus datasource | Auto-detect |
| `$receiver` | Receiver type filter | All receivers |
| `$processor` | Processor type filter | All processors |
| `$exporter` | Exporter type filter | All exporters |

## Drill-down Configuration

### Link to Logs (TODO)

```json
{
  "links": [
    {
      "title": "View Collector Logs",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"$datasource_logs\",\"expr\":\"{app=\\\"otel-collector\\\",level=\\\"error\\\"}\"}]}"
    }
  ]
}
```

## Known Issues

- No direct correlation with backend telemetry sinks
- Pipeline filtering requires proper metric labeling
- Memory metrics can be high-cardinality

## Future Improvements

- [ ] Add Loki drill-down for collector errors
- [ ] Add Tempo correlation for collector traces
- [ ] Add alert annotations for queue saturation
- [ ] Add per-pipeline throughput graphs
- [ ] Add resource attribute cardinality panels

## Related Dashboards

- **Loki Dashboard** - For log export correlation
- **Tempo Dashboard** - For trace export correlation
- **Prometheus Dashboard** - For metric export correlation