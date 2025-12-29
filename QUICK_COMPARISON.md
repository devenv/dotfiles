# Claude Code vs Cursor: Quick Reference

## At a Glance

| Category | Claude Code | Cursor | Winner |
|----------|------------|--------|--------|
| **Architecture** | Terminal-first agent | VS Code-based IDE | Claude Code |
| **Automation** | Native (slash commands, subagents, hooks) | Limited (agent mode, no hooks) | Claude Code |
| **Skill System** | Yes (priority-based auto-routing) | No | Claude Code |
| **Safety/Sandboxing** | Mature (OS-level isolation) | YOLO mode + MCP trust bypass gap | Claude Code |
| **Multi-Tenancy** | Supported with discipline | Not designed | Claude Code |
| **Configuration** | Project + global + instruction hierarchy | Global + project (basic) | Claude Code |
| **Integration Scale** | Unlimited MCPs + CLI tools | First 40 tools only | Claude Code |
| **Context Window** | 200K-1M tokens | Semantic indexing | Claude Code for large codebases |
| **Hands-on Development** | Less interactive | Native IDE experience | Cursor |
| **Headless/CI** | Designed for it | Not designed | Claude Code |
| **Cost per Operation** | ~4x Cursor | Lower per-op but limited use | Depends on workflow |

---

## When to Use Each

### Use Claude Code When:

✓ Autonomous operations needed (hands-off execution)
✓ Multi-step workflows (investigate → fix → validate)
✓ Multi-service orchestration (30+ microservices)
✓ Batch/overnight operations (reprocessing, migrations)
✓ Complex investigations (balance reconciliation, forecast debugging)
✓ Skill-based routing preferred (28+ domain workflows)
✓ Team-wide workflow consistency needed (.claude/commands in git)
✓ Headless/CI integration required
✓ Multi-tenant data safety critical

### Use Cursor When:

✓ Writing new features (interactive, hands-on coding)
✓ Code review & refactoring (visual feedback)
✓ Pull request workflow integration (GitHub-native)
✓ Interactive debugging required (IDE UI helpful)
✓ Developer prefers IDE workflow
✓ Quick edits & suggestions (tab completion, Cmd+K)
✓ VS Code extensions needed

---

## Safety Scorecard

### Claude Code

| Feature | Status | Notes |
|---------|--------|-------|
| Permission-based access | ✓ Mature | Read-only by default |
| OS-level sandboxing | ✓ Mature | Linux bubblewrap, macOS seatbelt |
| Confirmation gates | ✓ Good | But: payload splitting bypasses possible |
| Multi-tenant isolation | ~ Capable | Requires explicit nilus_id filtering (no auto-enforcement) |
| Hooks system | ✓ Excellent | Can enforce standards, validate operations |
| Destructive command protection | ~ Gaps | Known vulns: can execute despite warnings |

### Cursor

| Feature | Status | Notes |
|---------|--------|-------|
| Permission-based access | ✓ Basic | Auto Run Mode can be disabled |
| OS-level sandboxing | N/A | IDE-based, inherits OS user context |
| Approval gates | ✗ Gap | YOLO mode bypasses entirely |
| Multi-tenant isolation | ✗ No | Not designed for multi-tenant |
| MCP validation | ✗ Critical Gap | Trust-once, never re-check (MCP poison vulnerability) |
| Auto-run safety | ✗ Gap | No hooks to validate before execute |

---

## Automation Capability Pyramid

### Claude Code (Layers 1-5: All Present)

```
Layer 5: Issue Triage + Priority Routing
         └─ Autonomous skill selection based on request
Layer 4: Headless CI/Cron Execution
         └─ Runs without user; validates, reports
Layer 3: Hooks + Safety Validation
         └─ Pre-execution gates for dangerous ops
Layer 2: Subagents + Skill Delegation
         └─ Task-specific agents with isolated context
Layer 1: Slash Commands + CLI Tools
         └─ Base automation building blocks
```

### Cursor (Layers 1-2 Only)

```
Layer 2: Agent Mode (Newer, less documented)
         └─ Bigger than Cmd+K, smaller than full autonomy
Layer 1: Tab Completion + Cmd+K + YOLO Mode
         └─ Code suggestions and targeted edits
```

---

## Integration Ecosystem

### Claude Code Integrations

- **Metabase**: Queries, dashboard creation, BI analysis
- **Coralogix**: Log search, observability, pattern detection
- **Linear**: Issue creation, updates, linking to code
- **GitHub**: Deep codebase understanding, PR automation
- **PostgreSQL/Databases**: SQL queries, data inspection
- **Custom APIs**: Any MCP-wrapped service
- **CLI Tools**: All bash tools (kubectl, docker, git, etc.)
- **Capacity**: Unlimited MCPs

### Cursor Integrations

- Same MCP ecosystem as Claude Code (but newer adoption)
- Supabase, Vercel, SonarQube examples
- All VS Code extensions compatible
- **Capacity**: First 40 tools only (hard limit)

---

## Configuration & Customization

### Claude Code

```
.claude/
├── CLAUDE.md              # Project-level instructions + precedence rules
├── commands/
│   ├── fix-forecast.md    # Slash command
│   ├── debug-balance.md   # Slash command
│   └── ...
├── hooks/
│   ├── validate-nilus-id.md   # Pre-execution validation
│   ├── format-on-save.md       # Post-execution action
│   └── ...
└── agents/
    └── ...

.mcp.json                   # Project-scope MCP servers

~/.claude/                  # User-level (global)
├── commands/               # User's personal commands
└── ...

~/.claude/CLAUDE.md         # User's personal instructions
```

### Cursor

```
.cursor/
└── mcp.json               # Project MCP config

~/.cursor/
└── mcp.json               # Global MCP config
```

---

## Real-World Fintech Scenarios

### Scenario 1: Balance Reconciliation (Recurring Daily Task)

**Claude Code Approach**:
```
User: "Reconcile balance for org 121"
↓
1. Auto-routes to balance-reconciliation skill
2. Queries Metabase for expected vs actual
3. Identifies discrepancy root cause
4. Fixes code or reprocesses data as needed
5. Validates reconciliation with new query
6. Reports findings and actions taken
(All autonomous, no intervention)
```

**Cursor Approach**:
```
Developer must:
1. Manually open Metabase
2. Run queries to identify issue
3. Ask Cursor for suggestions
4. Manually apply fixes
5. Manually run tests
6. Manually validate
(All interactive, developer-driven)
```

**Winner**: Claude Code (60% faster, no developer context-switching)

### Scenario 2: New Feature Implementation

**Claude Code Approach**:
```
User describes feature requirements
→ Claude Code plans implementation
→ Creates design doc
→ But: Developer must review/approve before execution
(Overkill for simple features)
```

**Cursor Approach**:
```
Developer sits in IDE
→ Types/refines feature code
→ Gets AI suggestions at each step
→ Runs tests in IDE
→ Commits directly
(Hands-on, iterative, efficient)
```

**Winner**: Cursor (more natural workflow)

### Scenario 3: Production Debug Investigation (2 AM Alert)

**Claude Code Approach**:
```
Alert fires → On-call engineer triggers
→ `claude investigate forecast-issue --org 97`
→ Claude Code (headless) runs autonomously
→ Analyzes logs, queries data, identifies root cause
→ Suggests fix or escalates to engineer
→ Complete report ready by morning
(Engineer gets results without being awake)
```

**Cursor Approach**:
```
Alert fires → Engineer wakes up
→ Manually opens Cursor + Metabase + Logs
→ Investigates interactively
→ Takes 45 min in middle of night
(Worse DX, more human error risk)
```

**Winner**: Claude Code (fintech SLA compliance)

---

## Cost Comparison

### Small Team (1-5 developers)

| Tool | Monthly Cost | Usage Pattern |
|------|------------|--------------|
| Claude Code | $200-500 | Automation + ad-hoc investigations |
| Cursor | $100-150 | Daily interactive development |
| **Both** | $300-650 | Hybrid (Cursor for dev, Claude for ops) |

**Notes**: Cursor cheaper for pure development, but Claude Code's automation saves developer time (hidden value).

### Fintech Operations (24/7 automation)

| Operation | Claude Code | Manual + Cursor | Savings |
|-----------|------------|-----------------|---------|
| Nightly reprocessing | $0.20/run | 1 dev-hour ≈ $40-50 | 99% |
| Balance reconciliation | $0.15 per org | Manual + 30 min ≈ $15-20 | 95% |
| Forecast verification | $0.10 | Manual + 15 min ≈ $7-10 | 98% |
| **Weekly Total** | ~$20 | ~$2000-3000 | 99% |

**Verdict**: Claude Code ROI is massive for automated operations.

---

## Security Risk Summary

### Claude Code Risks (Low-Medium)

1. Cross-tenant data leakage (no auto-enforcement of nilus_id)
   - **Mitigation**: Implement hook system
   - **Likelihood**: Medium (developer discipline)

2. Destructive command execution despite warnings
   - **Mitigation**: Hooks, but vulnerabilities documented
   - **Likelihood**: Low (sandboxing catches most)

3. Payload splitting bypasses
   - **Mitigation**: Keep prompt clear, validate results
   - **Likelihood**: Low (requires deliberate attack)

### Cursor Risks (High)

1. MCP Trust Bypass (critical vulnerability 2025)
   - **Mitigation**: Regular security audits of MCPs
   - **Likelihood**: High (supply chain attack possible)

2. YOLO Mode auto-execute without validation
   - **Mitigation**: Keep disabled in production
   - **Likelihood**: High (if YOLO enabled)

3. Prompt injection attacks
   - **Mitigation**: Strict Allow List Mode
   - **Likelihood**: Medium (without whitelisting)

---

## Decision Matrix for Nilus

### Will Claude Code cover this use case?

```
Multi-step autonomous work?
  ├─ YES → Claude Code ✓
  └─ NO → Investigate further

Interactive development work?
  ├─ YES → Consider Cursor
  └─ NO → Probably Claude Code

Need skill-based routing?
  ├─ YES → Claude Code only ✓
  └─ NO → Either works

Multi-service operation?
  ├─ YES → Claude Code (better scaling)
  └─ NO → Either works

Headless/CI execution?
  ├─ YES → Claude Code only ✓
  └─ NO → Either works

FINAL: If ANY YES above → Claude Code is better fit
       If ALL NO → Cursor acceptable for interactive work
```

---

## Recommendation Summary

### For Nilus Platform

**Primary**: Claude Code
- Autonomous operations (balance reconciliation, reprocessing, migrations)
- Skill-based routing for 28+ workflows
- Multi-service orchestration (30+ microservices)
- Multi-tenant safety (with hooks enforcement)
- Headless/CI integration for overnight jobs

**Secondary**: Cursor
- Interactive feature development
- Code review and refactoring
- Pull request workflows
- Developer hands-on coding

**Implementation**:
1. Set up Claude Code with skills system + hooks
2. Configure MCP servers (Metabase, Coralogix, Linear)
3. Implement multi-tenant validation hooks
4. Migrate existing 28 workflows to skill system
5. Use Cursor for interactive development as-needed
6. Integrate both into CI/workflow (Claude Code for automation, Cursor for review)

---

## Further Reading

See `CLAUDE_CODE_VS_CURSOR_ANALYSIS.md` for:
- Full capabilities breakdown
- Detailed safety analysis
- Implementation recommendations
- Integration guides
- Cost analysis
- All sources and citations
