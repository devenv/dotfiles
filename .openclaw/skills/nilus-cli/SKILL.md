---
name: nilus-cli
description: Use Nilus ai-instructions CLI for Metabase queries, Coralogix log search, S3 storage operations, and skill discovery. Use for "query database", "search logs", "check Metabase", "find skill".
metadata: { "openclaw": { "emoji": "🛠️" } }
---

# Nilus AI-Instructions CLI

**Location**: `/Users/devenv/nilus/core/ai-instructions/`

## Skill Discovery
```bash
cd /Users/devenv/nilus/core

# List all skills
./ai-instructions/run skills list

# Group by verb (debug-*, investigate-*, etc)
./ai-instructions/run skills by-verb

# Search for specific skill
./ai-instructions/run skills find "kafka"
./ai-instructions/run skills find "forecast"
```

## Metabase Queries

### Database IDs
| ID | Database | Use For |
|----|----------|---------|
| 2 | transactions_prod | transactions, data flows, external records |
| 13 | cash-flow | cash balances, forecasts |

### Query Transactions DB
```bash
./ai-instructions/run metabase query transactions "
SELECT * FROM external_transactions
WHERE nilus_id = 97 LIMIT 10;
"
```

### Query Cash-Flow DB
```bash
./ai-instructions/run metabase query 13 "
SELECT * FROM cash_balances
WHERE nilus_id = 97 LIMIT 10;
"
```

### Common Queries
```bash
# Organization lookup
./ai-instructions/run metabase query transactions "
SELECT id, name FROM niluses WHERE name ILIKE '%company%';
"

# Data sources for org
./ai-instructions/run metabase query transactions "
SELECT id, name, type FROM data_sources WHERE nilus_id = <ID>;
"

# Recent data flows
./ai-instructions/run metabase query transactions "
SELECT df.id, df.status, df.start_time, ds.name as data_source
FROM data_flows df
JOIN data_sources ds ON df.data_source_id = ds.id
WHERE df.nilus_id = <ID>
ORDER BY df.start_time DESC LIMIT 20;
"
```

## Coralogix Log Search

### Basic Search
```bash
./ai-instructions/run coralogix query "level:ERROR" "<START_ISO>" "<END_ISO>"
```

### Service-Specific
```bash
# Integrations service
./ai-instructions/run coralogix query "kubernetes.labels.app:integrations-api" "<start>" "<end>"

# Transactions service
./ai-instructions/run coralogix query "service:transactions AND error" "<start>" "<end>"

# API Gateway errors
./ai-instructions/run coralogix query "kubernetes.labels.app:api-gateway AND status:5*" "<start>" "<end>"
```

### With Trace ID
```bash
./ai-instructions/run coralogix query "trace_id:<TRACE_ID>" "<start>" "<end>"
```

## S3 Storage Operations

### Fetch File
```bash
./ai-instructions/run storage fetch "s3://safe-raw-data--nls-prod-prod/<path>" \
  --profile nls-prod --output /tmp/

./ai-instructions/run storage fetch "s3://nilus-parsed-vendor-data--prod-prod/<path>" \
  --profile prod --output /tmp/
```

### List Files
```bash
./ai-instructions/run storage list "s3://safe-raw-data--nls-prod-prod/prod__<NILUS_ID>/" \
  --profile nls-prod
```

## Environment
```bash
# Required env vars (usually in shell profile)
METABASE_API_KEY=...
METABASE_URL=https://metabase.nilus.io
CORALOGIX_API_KEY=...
```

## Full Documentation
- CLI Reference: `ai-instructions/CLI_REFERENCE.md`
- Metabase Guide: `ai-instructions/integrations/metabase/`
- Coralogix Guide: `ai-instructions/integrations/coralogix/`
