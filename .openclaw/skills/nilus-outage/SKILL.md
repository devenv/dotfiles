---
name: nilus-outage
description: Investigate Nilus production outages and service issues. Use for "production down", "service errors", "customers affected", "urgent issue".
metadata: { "openclaw": { "emoji": "🚨" } }
---

# Nilus Outage Investigation

**Full skill**: `/Users/devenv/nilus/core/ai-instructions/skills/outage-investigation/SKILL.md`

## Quick Start (First 5 Minutes)

### 1. Check Pod Status
```bash
kubectl get pods -n prod | grep -E "(Error|CrashLoop|Pending|0/)"
kubectl get pods -n prod  # Full view
```

### 2. Check Recent Errors (Coralogix)
```bash
cd /Users/devenv/nilus/core
./ai-instructions/run coralogix query "level:ERROR" "$(date -u -v-30M +%Y-%m-%dT%H:%M:%SZ)" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
```

### 3. Check API Gateway Errors
```bash
./ai-instructions/run coralogix query "kubernetes.labels.app:api-gateway AND (status:5* OR status:4*)" "<30min ago>" "<now>"
```

### 4. Check Kafka Lag
```bash
kubectl exec -n prod kafka-0 -- kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --describe --all-groups 2>/dev/null | grep -v "^$" | sort -t' ' -k6 -rn | head -20
```

## Key Services & Pods

| Service | Pods | Purpose |
|---------|------|---------|
| api-gateway | api-gateway-* | Request routing |
| integrations-api | integrations-api-* | File uploads, data sources |
| integrations-consumer | integrations-consumer-* | Process uploaded files |
| transactions-api | transactions-api-* | Transaction CRUD |
| cash-flow-api | cash-flow-api-* | Cash flow projections |

## Common Issues

### High Kafka Lag
```bash
# Find lagging consumer
kubectl exec -n prod kafka-0 -- kafka-consumer-groups.sh --describe --group <GROUP>

# Check consumer logs
kubectl logs -n prod <consumer-pod> --tail=200 | grep -i error
```

### Database Connection Issues
```bash
./ai-instructions/run coralogix query "connection refused OR timeout OR deadlock" "<start>" "<end>"
```

### Memory/CPU Issues
```bash
kubectl top pods -n prod | sort -k3 -rn | head -10  # By memory
kubectl top pods -n prod | sort -k2 -rn | head -10  # By CPU
```

## Restart Procedures
```bash
# Single pod restart
kubectl delete pod <pod-name> -n prod

# Deployment rollout restart
kubectl rollout restart deployment/<name> -n prod

# Check rollout status
kubectl rollout status deployment/<name> -n prod
```

## Escalation
1. Check #incidents in Slack
2. Page on-call if customer-facing
3. Document in Linear (SUP- ticket)
