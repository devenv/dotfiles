---
name: nilus-data-flow
description: Investigate Nilus data flow pipeline failures - files in S3 not creating transactions, duplicate key violations, parser errors, stuck processing. Use for "files not processing", "data flow stuck", "missing data after upload".
metadata: { "openclaw": { "emoji": "🔄" } }
---

# Nilus Data Flow Troubleshooting

**Full skill**: `/Users/devenv/nilus/core/ai-instructions/skills/data-flow-troubleshooting/SKILL.md`

## Quick Reference

### Check Data Flow Status
```bash
cd /Users/devenv/nilus/core
./ai-instructions/run metabase query transactions "
SELECT
    df.id, df.status, df.source_uri,
    COUNT(CASE WHEN dfs.status = 'completed' THEN 1 END) as completed,
    COUNT(CASE WHEN dfs.status = 'failed' THEN 1 END) as failed
FROM data_flows df
LEFT JOIN data_flow_steps dfs ON dfs.data_flow_id = df.id
WHERE df.nilus_id = <NILUS_ID>
    AND df.start_time >= '<DATE>'
GROUP BY df.id
ORDER BY df.start_time DESC LIMIT 20;
"
```

### Check Error Messages
```bash
./ai-instructions/run metabase query transactions "
SELECT dfs.error_message, df.source_uri
FROM data_flow_steps dfs
JOIN data_flows df ON df.id = dfs.data_flow_id
WHERE dfs.status = 'failed'
    AND df.nilus_id = <NILUS_ID>
    AND df.start_time >= '<DATE>'
LIMIT 10;
"
```

### Check Records Created
```bash
./ai-instructions/run metabase query transactions "
SELECT COUNT(*) FROM external_balances
WHERE nilus_id = <NILUS_ID> AND created_at >= '<DATE>';
"
```

### Download S3 File
```bash
./ai-instructions/run storage fetch "s3://safe-raw-data--nls-prod-prod/<SOURCE_URI>" \
  --profile nls-prod --output /tmp/investigation/
```

### Search Logs
```bash
./ai-instructions/run coralogix query "service:integrations AND error" "<START>" "<END>"
```

## Decision Tree

| Pattern | Meaning | Action |
|---------|---------|--------|
| status=completed, failed=0 | ✅ Success | Done |
| failed>0, error contains "unique constraint" | ⚠️ Duplicates | Expected - check if new records created |
| failed>0, error contains "KeyError/ValueError" | ❌ Parser error | Download file, check format |
| status=processing > 30min | 🔄 Stuck | Check pod health, restart if needed |

## Pod Health
```bash
kubectl get pods -n prod | grep integrations-api
kubectl logs integrations-api-xxx -n prod --tail=100
kubectl top pod -n prod | grep integrations
```

## Related Skills
- `reprocess-s3-files` - Reprocess after fixing
- `integrations-health-check` - Verify connectivity
- `trace-data-pipeline` - End-to-end tracing
