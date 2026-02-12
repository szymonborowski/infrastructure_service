# Infrastructure

Shared infrastructure layer for the portfolio microservices platform. Provides API gateway, message queue, and a complete observability stack (metrics, logs, dashboards).

## Architecture

```
                    ┌─────────────────────────────────────────┐
                    │              Traefik (Gateway)           │
                    │         TLS termination + routing        │
                    └────┬────┬────┬────┬────┬────┬───────────┘
                         │    │    │    │    │    │
                   Frontend Blog Users SSO Admin Analytics
                         │    │         │
                         ▼    ▼         ▼
                       ┌──────────────────┐
                       │    RabbitMQ       │
                       │  (message queue)  │
                       └──────────────────┘

    ┌──────────────────────────────────────────────────────┐
    │                 Observability Stack                   │
    │  Promtail ──▶ Loki ──▶ Grafana ◀── Prometheus       │
    │  (log shipper)  (logs)  (dashboards)  (metrics)      │
    └──────────────────────────────────────────────────────┘
```

## Components

### Traefik (API Gateway)

- **Version:** 3.6
- **Domain:** `traefik.microservices.local`
- **Ports:** 80 (HTTP), 443 (HTTPS), 8080 (dashboard)
- **Features:** TLS termination, Docker service discovery, health checks, dynamic routing

### RabbitMQ (Message Queue)

- **Version:** 3-management-alpine
- **Domain:** `rabbitmq.microservices.local`
- **Ports:** 5672 (AMQP), 15672 (management UI)
- **Used by:** Users (publisher), Blog consumer, Analytics consumer

### Prometheus (Metrics)

- **Version:** 2.51.0
- **Domain:** `prometheus.microservices.local`
- **Port:** 9090
- **Retention:** 30 days
- **Scrapes:** All service metrics via Traefik

### Loki (Log Aggregation)

- **Version:** 3.0.0
- **Port:** 3100
- **Role:** Centralized log storage (receives logs from Promtail)

### Promtail (Log Shipper)

- **Version:** 3.0.0
- **Role:** Reads Docker container logs (stderr) and ships to Loki

### Grafana (Dashboards)

- **Version:** 10.4.0
- **Domain:** `grafana.microservices.local`
- **Port:** 3000
- **Default credentials:** admin / admin
- **Provisioned datasources:** Prometheus, Loki
- **Dashboards:** Portfolio services overview, Loki logs explorer

## Networks

| Network | Type | Purpose |
|---------|------|---------|
| `web` | External | Traefik routing to services |
| `microservices` | Internal | Service-to-service communication |

## Getting Started

### Prerequisites

- Docker & Docker Compose

### Development

```bash
cp .env.example .env
# Edit .env with your configuration

docker compose up -d
```

This should be started **before** all other services (they depend on Traefik and RabbitMQ networks).

### Accessing Dashboards

| Service | URL |
|---------|-----|
| Traefik | `https://traefik.microservices.local` |
| RabbitMQ | `https://rabbitmq.microservices.local` |
| Grafana | `https://grafana.microservices.local` |
| Prometheus | `https://prometheus.microservices.local` |

## Configuration Files

| File | Purpose |
|------|---------|
| `traefik.yml` | Traefik static configuration |
| `dynamic/` | Traefik dynamic routing rules and TLS |
| `certs/` | TLS certificates |
| `prometheus.yml` | Prometheus scrape targets |
| `loki-config.yaml` | Loki storage and ingestion config |
| `promtail-config.yaml` | Promtail log collection config |
| `grafana/provisioning/` | Grafana datasource and dashboard provisioning |
| `grafana/dashboards/` | Custom Grafana dashboard definitions (JSON) |

## Roadmap

- [x] Traefik reverse proxy with TLS and Docker discovery
- [x] RabbitMQ with management UI
- [x] Prometheus metrics collection
- [x] Loki + Promtail log aggregation
- [x] Grafana dashboards (services overview, logs)
- [x] Kubernetes manifests (namespace, RabbitMQ StatefulSet)
- [ ] Alerting rules (pod restarts, error rate, DB connection failures)
- [ ] Kubernetes deployment of observability stack

## License

All rights reserved.
