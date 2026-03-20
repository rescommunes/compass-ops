# Cert-Manager Dashboard

## Overview

Dashboard for monitoring cert-manager certificate lifecycle. Provides visibility into certificate issuance, renewal, expiration status, and issuer health.

## Original Source

- **Dashboard ID:** 20842
- **Author:** Cert-Manager Community
- **Source URL:** https://grafana.com/grafana/dashboards/20842
- **License:** Apache 2.0
- **Last Updated:** 2024

**Modifications:**
- Fixed `${DS_PROMETHEUS}` → `$datasource` template variable
- Removed `__inputs` section for provisioning compatibility
- Fixed all panel datasource UIDs

## Requirements

### Metrics Required

Cert-manager must be installed and configured:

```yaml
# cert-manager installation
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: cert-manager
  namespace: kube-system
spec:
  repo: https://charts.jetstack.io
  chart: cert-manager
  version: v1.13.0
  valuesContent: |
    installCRDs: true
    prometheus:
      enabled: true
      servicemonitor:
        enabled: true
```

### Required Metrics

- `certmanager_certificate_ready_status` - Certificate ready status
- `certmanager_certificate_expiration_timestamp_seconds` - Certificate expiration
- `certmanager_issuer_ready_status` - Issuer ready status
- `certmanager_certificate_renewal_timestamp_seconds` - Next renewal time
- `certmanager_controller_http_request_total` - ACME request count

## Features

### Core Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| Certificate Status | ✅ | Ready/NotReady count |
| Expiration Tracking | ✅ | Days until expiration |
| Issuer Status | ✅ | Issuer health status |
| Renewal Status | ✅ | Pending renewals |

### Resource Metrics

| Feature | Status | Notes |
|---------|--------|-------|
| ACME Requests | ✅ | Rate of ACME operations |
| Certificate Count | ✅ | Total certificates by status |
| Issuer Count | ✅ | Total issuers by type |

### Context & Drill-down

| Feature | Status | Notes |
|---------|--------|-------|
| Link to Logs | ✅ | Can drill to cert-manager logs on errors |
| Link to Traces | N/A | Cert-manager doesn't produce traces |
| Time Range Sync | ✅ | Uses dashboard time range |
| Namespace Filtering | ✅ | Filter by Kubernetes namespace |

### Operational

| Feature | Status | Notes |
|---------|--------|-------|
| Certificate Health | ✅ | Status by certificate |
| Expiration Alerts | ✅ | Days until expiration |
| Issuer Errors | ✅ | Failed issuance attempts |
| Certificate Age | ✅ | Time since creation |

## Template Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `$datasource` | Prometheus datasource | Auto-detect |
| `$namespace` | Kubernetes namespace | All namespaces |

## Drill-down Configuration

### Link to Logs for Certificate Errors

```json
{
  "links": [
    {
      "title": "View Certificate Errors in Logs",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"${datasource_logs}\",\"expr\":\"{app=\\\"cert-manager\\\"} |= \\\"error\\\"\"}]}"
    }
  ]
}
```

### Link to Certificate Details

Certificates expiring soon should link to certificate status:

```json
{
  "links": [
    {
      "title": "View Certificate Status",
      "type": "link",
      "url": "/explore?left={\"queries\":[{\"datasource\":\"${datasource}\",\"expr\":\"certmanager_certificate_expiration_timestamp_seconds{namespace=\\\"$namespace\\\"}\"}]}"
    }
  ]
}
```

## Known Issues

- No automatic alerting for expiring certificates (set up separate alerts)
- ACME rate limiting not directly visible
- Certificate request failures require log correlation

## Future Improvements

- [ ] Add Loki drill-down for issuance failures
- [ ] Add certificate detail breakdown by DNS name
- [ ] Add cluster issuer monitoring
- [ ] Add ACME rate limit tracking
- [ ] Add certificate chain validation status

## Related Dashboards

- **Traefik Dashboard** - For ingress TLS correlation (traefik entrypoints)
- **Loki Dashboard** - For certificate error log correlation
- **Kubernetes Events Dashboard** - For certificate event correlation