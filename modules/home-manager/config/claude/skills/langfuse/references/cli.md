# Langfuse CLI Reference

## Install

```bash
# Run directly (recommended)
npx langfuse-cli api <resource> <action>
bunx langfuse-cli api <resource> <action>

# Or install globally
npm i -g langfuse-cli
langfuse api <resource> <action>
```

## Discovery

```bash
# List all resources and auth info
langfuse api __schema

# List actions for a resource
langfuse api <resource> --help

# Show args/options for a specific action
langfuse api <resource> <action> --help

# Preview the curl command without executing
langfuse api <resource> <action> --curl
```

## Credentials

Pass `--env ~/.config/langfuse/.env` on every command:

```bash
npx langfuse-cli --env ~/.config/langfuse/.env api <resource> <action>
```

The `.env` file should contain:
```
LANGFUSE_PUBLIC_KEY=pk-lf-...
LANGFUSE_SECRET_KEY=sk-lf-...
LANGFUSE_HOST=https://cloud.langfuse.com
```

## Common Examples

```bash
# List recent traces in development
npx langfuse-cli --env ~/.config/langfuse/.env api traces list --environment development --fields core,metrics

# List observations in development (GENERATION, SPAN, TOOL, AGENT, etc.)
npx langfuse-cli --env ~/.config/langfuse/.env api observations list --environment development --fields core,basic,usage,model --limit 50

# Filter observations by type
npx langfuse-cli --env ~/.config/langfuse/.env api observations list --environment development --type GENERATION --fields core,basic,usage,model

# Get all observations for a specific trace
npx langfuse-cli --env ~/.config/langfuse/.env api observations list --trace-id <traceId> --fields core,basic,io

# Get a single observation by ID (v2 — use --filter with id column)
npx langfuse-cli --env ~/.config/langfuse/.env api observations list \
  --filter '[{"type":"string","column":"id","operator":"=","value":"<observationId>"}]' \
  --fields core,basic,io,model,usage

# Paginate using cursor from previous response meta.cursor
npx langfuse-cli --env ~/.config/langfuse/.env api observations list --environment development --cursor <cursor>
```

### Observation field groups

| Group | Fields returned |
|-------|----------------|
| `core` | id, traceId, startTime, endTime, projectId, parentObservationId, type (always included) |
| `basic` | name, level, statusMessage, version, environment, userId, sessionId |
| `io` | input, output |
| `model` | providedModelName, internalModelId, modelParameters |
| `usage` | usageDetails, costDetails, totalCost |
| `metrics` | latency, timeToFirstToken |
| `prompt` | promptId, promptName, promptVersion |

## Tips

- Use `--json` for machine-readable JSON output
- Use `--curl` to preview the HTTP request without executing
- Pagination: use `--limit` and `--page` on list endpoints
- All list commands support filtering — check `<resource> <action> --help` for available options
- Use `observations` for querying observations — it supports cursor-based pagination and rich field selection
- Prefer `scores` over `legacy-score-v1s` for list and get operations
