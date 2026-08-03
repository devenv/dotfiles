# Claude Code vs Cursor: Comprehensive Analysis for Fintech Microservices

**Date**: December 12, 2025
**Context**: Evaluation for Nilus fintech platform (multi-tenant, microservices architecture with 200+ organizations)

---

## Executive Summary

| Dimension | Claude Code | Cursor | Winner for Fintech |
|-----------|------------|--------|-------------------|
| **Architecture** | Terminal-first agentic agent | IDE-based (VS Code fork) | Claude Code (better autonomous ops) |
| **Multi-step Automation** | Native, autonomous workflow | Interactive, user-guided | Claude Code (less intervention) |
| **Integration Ecosystem** | MCP-based, extensive | MCP-based, developing | Comparable |
| **Safety/Approval Gates** | Sandbox + permission model | YOLO mode + approval gaps | Claude Code (more mature) |
| **Configuration Flexibility** | Project + global scopes | Global + project scopes | Comparable |
| **Multi-tenancy Support** | Good with explicit guards needed | Not designed for it | Claude Code (better isolation) |
| **Skill Discovery** | Native skill system + subagents | No native equivalent | Claude Code (significant advantage) |

---

## 1. Tool Capabilities: Core Architecture

### Claude Code

**Terminal-First Design**:
- Command-line based AI agent with no GUI or interactive buttons
- Can understand and manipulate entire codebases deeply
- Inherits full bash environment with all CLI tools available
- Both MCP server AND MCP client (bidirectional integration)

**Agentic Capabilities**:
- Plans multi-step tasks autonomously
- Executes, checks results, fixes problems without user intervention
- Can sustain extended autonomous runs (advertised ~30 hours continuous operation with Sonnet 4.5)
- Context window: 200,000 tokens standard, up to 1,000,000 with extended context
- Reduces code rework by ~30% vs interactive tools, gets things right in 1-2 iterations

**Model Access**:
- Pro users: Access to Opus 4.5
- Can leverage Sonnet 4.5 for extended agentic operations
- SDK available for building custom agents (both coding and non-coding)

### Cursor

**IDE-Based Design**:
- VS Code fork with AI deeply integrated into editor DNA
- Fully featured IDE with all VS Code functionality
- Three entry points for code changes: tab completion, Cmd+K (surgical edits), agent mode
- Context via semantic indexing: turns entire codebase into embeddings for semantic map

**Automation Features**:
- YOLO Mode: Auto-applies AI-generated code changes without user confirmation (for speed)
- Agent Mode: Bigger task orchestration (newer feature)
- Visual Editor: New feature (2025) for drag-and-drop web app design within IDE
- Tab completion with custom model: 21% fewer suggestions, 28% higher accept rate

**Key Limitation for Autonomous Work**:
- Interactive by design—expects developer feedback at each step
- Better for hands-on coding; less suitable for pure automation
- Pricing: $20/month for 500 premium requests vs Claude Code (4x higher per-operation cost)

### Verdict
**Claude Code wins for autonomous multi-step operations**. Terminal-first + agentic design is purpose-built for hands-off automation. Cursor excels for interactive development but requires more developer intervention.

---

## 2. Automation Features

### Claude Code Automation

**Slash Commands**:
- Custom commands via `.claude/commands` folder
- Files are markdown with natural language + `$ARGUMENTS` placeholder
- Support for team-specific, project-specific workflows
- Can be checked into git for team consistency

**Subagents**:
- Specialized AI assistants for specific task types
- Each has custom system prompt, specific tools, separate context window
- Prevents context pollution through isolation
- Auto-routed based on task type (when Claude detects match)

**Hooks System**:
- Scripts that intercept operations before execution
- Act as safety net: catch dangerous operations, allow safe ones automatically
- SessionStart hook for new session initialization
- Used for automatic standards enforcement and event-triggered actions
- Taming YOLO mode: Can validate before dangerous operations

**Plugins**:
- Custom collections of slash commands, agents, MCP servers, and hooks
- Install with single command
- Extensible system for team workflows

**Headless Mode**:
- Non-interactive for CI, pre-commit hooks, build scripts
- Triggers via GitHub events (new issue, PR, push)
- Can power automated GitHub workflows (auto-labeling, auto-assignment)

**Skill System** (Unique to Claude Code):
- Declarative prompt-based skill discovery
- Lightweight: scans at startup, loads only what's relevant
- No context penalty for having many skills
- Skills are model-invoked (Claude decides autonomously when to use)
- Can include priority tiers and triage logic
- Workflow: Load SKILL.md → expand into instructions → modify context → continue conversation

**Routing & Triage**:
- Issue Triage System for GitHub issues (auto-classification, labeling)
- Potential for implementing deterministic triage algorithms
- Example: Priority-based skill selection (P1-P28 system possible)

### Cursor Automation

**Agent Mode**:
- Designed for bigger tasks than Cmd+K edits
- Less documented than Claude Code subagents
- Less mature than Claude Code's automation system

**YOLO Mode**:
- Auto-apply changes without confirmation
- Speed-focused for repetitive/low-risk changes
- **Safety Gap**: No hooks to validate before auto-apply

**Configuration via MCP**:
- Can connect to external tools/services
- But: currently limited to first 40 tools if many MCPs active
- No native skill discovery system

**GitHub Integration**:
- Tighter integration with GitHub (PR reviews, test generation)
- But: less emphasis on headless/CI automation

### Verdict
**Claude Code wins decisively for automation**. Slash commands, subagents, hooks, and skill system provide layered automation. Cursor's YOLO mode is fast but lacks safety validation. Claude Code's headless mode + skill system is purpose-built for hands-off fintech operations.

---

## 3. Configuration Systems

### Claude Code Configuration

**File Locations & Scopes**:
- **Global**: `~/.claude/` directory for user-wide settings
- **Project**: `.claude/` directory in repository root
- **MCP Config**: Two scopes for MCP servers
  - Global: `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS path)
  - Project: `.mcp.json` in repository (can be committed to git)

**Configuration Components**:
- **Slash Commands**: `.claude/commands/*.md` files
- **Hooks**: `.claude/hooks/` for pre-execution validation scripts
- **MCP Servers**: `.mcp.json` or global config
- **Stored Prompts**: Custom prompt templates
- **Skills**: Loaded from project/global locations

**CLI Setup**:
- `claude mcp add github --scope user` for MCP management
- Wizard for configuration OR direct JSON editing
- Project-scope MCP allows team-wide tool access without manual setup

**Instruction Hierarchy** (Explicit):
1. User's personal `.claude/CLAUDE.md` (highest priority)
2. Project `CLAUDE.md` (project-specific rules)
3. Skill-specific SKILL.md files (context-dependent)
4. General guides and documentation

**Auto-Loading**:
- Scans `.claude/` on startup
- Loads skills, commands, hooks based on relevance
- No manual registration needed

### Cursor Configuration

**File Locations & Scopes**:
- **Global**: `~/.cursor/mcp.json` for all workspaces
- **Project**: `.cursor/mcp.json` in project directory

**Configuration Components**:
- Primarily MCP servers via JSON config
- No native equivalent to slash commands, hooks, or skills
- Environment variables supported for authentication
- OAuth support for some MCPs

**MCP Management**:
- One-click setup from curated collection (with OAuth)
- Manual JSON configuration for custom MCPs
- Transport types: stdio (simple, local), SSE/HTTP (distributed)
- Language-agnostic: any language that can write to stdout or serve HTTP

**Limitations**:
- No instruction precedence/hierarchy system
- No native skill discovery
- No hooks system
- No slash command equivalent
- Limited to first 40 tools if many MCPs active

### Verdict
**Claude Code wins for configuration flexibility**. Multi-scope loading, skill system, hooks, and explicit instruction hierarchy make it superior for complex team environments. Cursor is simpler but less powerful for enterprise workflows.

---

## 4. Integration Ecosystem

### Claude Code Integrations

**MCP-Based Architecture**:
- Functions as both MCP server and client
- Can connect to unlimited MCP servers (by design)
- Ecosystem includes:
  - **Metabase**: AI-powered assistant for BI queries via MCP
  - **Linear**: Search, create, update issues via MCP
  - **Coralogix**: Natural language observability via MCP
  - **GitHub**: Deep codebase understanding
  - **PostgreSQL/Databases**: Via MCP connectors
  - **Custom APIs**: Any service with MCP wrapper

**Pre-Built Connectors**:
- Community-built MCP servers for ~50+ services
- Official integrations for major platforms
- Extensible: SDK allows building custom MCP servers

**Integration Quality**:
- Can use all CLI tools directly (no additional setup for bash-based tools)
- Inherits entire bash environment
- Can chain multiple integrations seamlessly

### Cursor Integrations

**MCP-Based Architecture**:
- Newer adoption of MCP vs Claude Code
- Same core integration potential
- Same MCP server ecosystem available

**Pre-Built Integrations**:
- One-click setup for popular MCPs (with OAuth)
- Limited to first 40 tools if many MCPs active
- Supabase, Vercel, SonarQube examples
- VS Code extension compatibility (all VS Code extensions work)

**Limitations**:
- Tool limit (first 40 tools only) is significant for multi-service fintech
- Less mature integration automation
- No CLI tool inheritance like Claude Code

### Verdict
**Claude Code wins for integration scale**. Unlimited MCP support + CLI inheritance makes it superior for microservices (Nilus has 30+ services). Cursor's 40-tool limit and VS Code extension dependency is restrictive for fintech.

---

## 5. Safety & Multi-Tenancy

### Claude Code Safety Model

**Permission-Based Architecture**:
- **Default**: Read-only, asks permission before modifications
- **Safe Commands**: Auto-allowed (echo, cat, ls, etc.) with ~76 pre-approved commands
- **Sandboxing**: OS-level isolation (Linux bubblewrap, macOS seatbelt)
  - Covers direct interactions AND all subprocesses
  - Can only write to working directory + subdirs
  - Read access outside working dir allowed (for libraries/deps)

**Confirmation Gates**:
- Permission prompts for dangerous operations
- Internal testing: sandboxing reduces permission prompts by 84%
- Web-based sessions: isolated VMs, network access controls by default

**Multi-Tenancy Support**:
- Sandbox provides filesystem isolation per execution
- Each user session runs in isolated VM (web version)
- Credentials never inside sandbox (git keys, signing keys separate)
- Supports isolated containers per user for true multi-tenancy (hundreds of orgs)

**Known Limitations**:
- **Vulnerability 1**: Destructive commands (e.g., `pnpm prisma migrate reset --force`) can execute despite user instructions to prevent them
- **Vulnerability 2**: Payload splitting can bypass defenses (malicious code runs after user confirmation)
- **Gap**: No explicit nilus_id filtering enforcement (relies on developer discipline)

### Cursor Safety Model

**Auto-Run & Approval Modes**:
- **Auto Run Mode**: Can execute without confirmation (can be disabled)
- **Allow List Mode**: Limit which commands are permitted
- File Deletion Protection: ON by default
- Dotfile Protection: ON by default

**Critical Safety Gaps**:
- **MCP Trust Bypass Vulnerability** (2025): Once MCP approved, future modifications trusted without re-validation. Cursor never re-checks approved MCPs even if commands are silently changed
- **Auto-Run Risks**: Without enforcement, rapid exploitation possible if malicious payload generated
- **Prompt Injection**: Agents can interpret natural language without strict sanitization; vulnerable to hidden malicious instructions

**Recommended Mitigations**:
- Turn off Auto Run Mode
- Enable Allow List Mode with minimal commands
- Keep File/Dotfile Protection ON
- Enable Workplace Trust
- Audit untrusted repos before opening

**Multi-Tenancy Support**:
- Not designed for multi-tenancy
- No explicit data isolation mechanisms documented
- IDE design assumes single user per instance

### Verdict
**Claude Code wins for safety and multi-tenancy**. Mature sandboxing + explicit isolation supports fintech needs (though gaps exist). Cursor's MCP approval bypass and YOLO mode are dealbreakers for production fintech. Neither tool explicitly enforces multi-tenant data scoping (like nilus_id filtering)—developer discipline required in both cases.

---

## 6. Skill/Workflow Systems

### Claude Code Skill System

**Native Skill Discovery**:
- Declarative, prompt-based system for skill metadata
- Lightweight: metadata in system prompt, no context penalty
- Skills scanned at startup and loaded as relevant
- Model-invoked: Claude autonomously decides when to use each skill

**Skill Components**:
- **SKILL.md**: Detailed task-specific instructions
- **Triggers**: Keywords that match user requests
- **Pre-conditions**: Environment requirements, minimum info needed
- **Priority Tiers**: P1-P28 system possible (criticality + specificity)

**Workflow When Skill Invoked**:
1. Load SKILL.md from filesystem
2. Expand into detailed instructions
3. Inject as new user messages into context
4. Modify execution environment (tools, model selection)
5. Continue conversation with enriched context

**Triage Algorithm** (Possible):
- Pre-condition filtering (eliminates skills missing env vars)
- Priority selection (lowest number wins)
- Specificity tie-breaking (more specific descriptions first)
- Rare user confirmation if still ambiguous

**Example Priority System** (as implemented in Nilus):
- **Tier 1 (P1-P3)**: Critical ops (restore-deleted-org, balance-reconciliation)
- **Tier 2 (P4-P8)**: Specific domain (forecast-verification, currency-conversion)
- **Tier 3 (P9-P16)**: Generic debugging (data-flow, performance)
- **Tier 4 (P17-P24)**: Dev workflows (run-tests, feature-flags)
- **Tier 5 (P25-P28)**: Support ops (reprocess, health-check)

**Real Implementation**:
- Nilus has 28 skills with explicit triggers in `skills/index.json`
- Skills organized by domain (debugging, operations, development, testing)
- Each skill has SKILL.md with prescribed commands (e.g., `./run forecast check`)

### Cursor Skill System

**No Native Equivalent**:
- No declarative skill discovery
- No auto-routing based on request type
- No priority/triage system
- No SKILL.md equivalent

**Alternatives**:
- Agent mode (newer, less documented)
- Could potentially use slash commands via MCP (but not native)
- Relies on user explicit prompting

### Verdict
**Claude Code wins decisively**. Native skill system with auto-discovery, priority triage, and pre-condition filtering is unique to Claude Code. For Nilus' 28+ domain-specific workflows, this is a massive advantage. Cursor has no equivalent.

---

## 7. Detailed Capability Matrix

### Multi-Service Orchestration (Nilus: 30+ microservices)

| Feature | Claude Code | Cursor | Notes |
|---------|------------|--------|-------|
| Understand all services at once | Yes (200K context) | Via indexing | Claude Code clearer |
| Auto-route to service-specific skill | Yes | No | Claude Code only |
| Run tests across services | Yes (cli + skill system) | IDE-only | Claude Code better for CI |
| Monorepo support | Excellent | Good (VS Code) | Comparable |
| Database query integration | MCP + native CLI support | MCP only | Claude Code cleaner |

### Autonomous Operations (Fintech needs)

| Feature | Claude Code | Cursor | Notes |
|---------|------------|--------|-------|
| Multi-step without intervention | Yes (designed for this) | User-guided | Claude Code wins |
| Run to completion | Yes (30+ hours advertised) | Limited sessions | Claude Code wins |
| Fix errors autonomously | Yes (sees output, adapts) | Requires user input | Claude Code wins |
| Parallel operations | Yes (via subagents) | Single IDE instance | Claude Code wins |
| Schedule/headless execution | Yes (CI mode) | Not designed | Claude Code only |

### Team Workflows (Multi-developer)

| Feature | Claude Code | Cursor | Notes |
|---------|------------|--------|-------|
| Shareable commands | Yes (.claude/commands in git) | No native equivalent | Claude Code only |
| Team-wide MCP setup | Yes (.mcp.json in git) | Manual per dev | Claude Code wins |
| Instruction hierarchy | Yes (explicit precedence) | No | Claude Code only |
| Code review automation | Possible via skills | Built-in | Comparable |
| Bug triage automation | Yes (issue triage skill) | Manual | Claude Code only |

### Fintech-Specific Operations

| Feature | Claude Code | Cursor | Notes |
|---------|------------|--------|-------|
| Multi-tenant data isolation | Sandbox per execution | Not designed | Claude Code better |
| Balance reconciliation automation | Via skill system | Manual investigation | Claude Code wins |
| Forecast verification | Via skill system + Metabase MCP | Manual queries | Claude Code wins |
| Cross-org data safety | Requires discipline (nilus_id filtering) | No isolation | Both weak here |
| Kafka lag investigation | Via skill system + Coralogix MCP | Manual setup | Claude Code wins |

---

## 8. Real-World Usage Patterns

### Claude Code Typical Workflow (Autonomous)

```
User: "Forecast is wrong for org 97, investigate"
↓
Claude Code:
1. Auto-routes to forecast-debugging skill
2. Loads SKILL.md with detailed investigation steps
3. Queries Metabase via MCP for org 97 data
4. Checks recent transactions
5. Reviews forecast calculation code
6. Identifies root cause (missing FX rate)
7. Fixes code AND reprocesses data
8. Validates results with new query
9. Reports findings with evidence
(All without user intervention)
```

### Cursor Typical Workflow (Interactive)

```
User: "Forecast is wrong for org 97"
↓
Developer opens Cursor
1. Types query in file/ask Claude panel
2. Claude suggests investigation steps
3. Developer manually runs queries in Metabase
4. Claude suggests code changes
5. Developer reviews suggestions
6. Developer approves changes
7. Developer runs tests
8. Developer commits changes
(Requires continuous developer attention)
```

---

## 9. Cost Analysis for Fintech Operations

| Operation | Claude Code Cost | Cursor Cost | Volume Impact |
|-----------|-----------------|------------|----------------|
| Investigation + Fix (10K tokens) | ~$0.15 | ~$0.10 | High volume |
| Autonomous overnight reprocess | Efficient | N/A (can't do) | Weekly/monthly |
| Multi-service refactor | ~$2-5 | Manual developer (hours) | Quarterly |
| Skill-based routing | Minimal | N/A (no skills) | Continuous |

**Fintech Reality**: Frequent multi-service operations make Claude Code's higher per-operation cost worthwhile due to:
1. Speed (less developer context-switching)
2. Automation (runs headless at 3 AM for reprocessing)
3. Reliability (no human error in complex multi-step ops)
4. Auditability (complete execution logs for compliance)

---

## 10. Critical Gaps & Risks

### Claude Code Gaps

1. **Multi-tenant Data Leakage Risk**:
   - No built-in enforcement of nilus_id filtering
   - Relies entirely on developer discipline
   - **Mitigation**: Hooks system can enforce (but must be configured)
   - **Risk**: Cross-org queries possible if developer forgets WHERE clause

2. **Destructive Command Execution**:
   - Documented vulnerability: Can execute reset commands despite "don't overwrite" instructions
   - Payload splitting can bypass security
   - **Mitigation**: Use hooks to validate before destructive operations

3. **Context Window Limits**:
   - 1M token max may be insufficient for largest codebases
   - Nilus has ~200K+ lines across 30+ services

### Cursor Gaps

1. **MCP Trust Bypass**:
   - Once approved, MCPs auto-trusted forever
   - **Risk**: Supply chain attack (MCP maliciously modified)
   - **Mitigation**: Requires regular security audits of MCP source code

2. **YOLO Mode + No Validation**:
   - Auto-apply without hooks/validation
   - **Risk**: Malicious prompt injection can lead to code execution
   - **Mitigation**: Keep YOLO off in production contexts

3. **No Skill System**:
   - 28+ workflows must be manually documented
   - **Risk**: Developer chooses wrong approach/tool
   - **Mitigation**: Custom MCP server needed to replicate (expensive)

4. **Tool Limit (40 MCPs)**:
   - Nilus has 30+ services, each needing integration
   - **Risk**: Can't integrate all services simultaneously
   - **Mitigation**: Rotate MCPs or build custom integration

---

## 11. Recommendation for Nilus

### Best-Fit Scenario: Claude Code as Primary Agent

**Why**:
1. **Autonomous Operations**: Fintech needs hands-off processing (balance reconciliation, reprocessing, migrations)
2. **Skill System**: 28+ domain-specific workflows benefit from auto-discovery and triage
3. **Multi-Service**: 30+ microservices + 200+ organizations require robust automation
4. **Integration**: Metabase, Coralogix, Linear via MCP + native CLI tools (Kafka, kubectl, etc.)
5. **Headless**: Can run in CI/cron for overnight reprocessing without developer

### Supplementary Scenario: Cursor for Interactive Development

**Use Cases**:
- Writing new feature code (hands-on development)
- Code review and refactoring (visual feedback)
- Interactive debugging (UI-based)
- Pull request comments and GitHub integration

### Hybrid Approach (Optimal)

```
Development Workflow:
├── Interactive Development → Cursor (IDE)
├── Code Review → Claude Code (via subagent skill)
├── Testing → Claude Code (skill-based test routing)
├── Investigation → Claude Code (auto-selects skill)
├── Operations → Claude Code (autonomous reprocessing)
└── Overnight Batch Jobs → Claude Code (headless mode)
```

### Critical Implementation Requirements

1. **Multi-Tenancy Safety**:
   - Implement hook system to enforce `nilus_id` filtering
   - Create `.claude/hooks/validate-nilus-id.md` to block cross-org queries
   - Document in CLAUDE.md with critical rule override

2. **Skill System Setup**:
   - Migrate 28 existing workflows to `.claude/commands/` with priority tiers
   - Create skill discovery documentation in `skills/index.json`
   - Implement triage algorithm to prevent wrong skill selection

3. **MCP Integration**:
   - Metabase, Coralogix, Linear via official MCP servers
   - Add `.mcp.json` to git (project scope)
   - Document environment variable requirements

4. **Headless Operations**:
   - CI/cron integration for nightly reprocessing
   - GitHub Actions triggers (new issue = auto-triage)
   - Cleanup/error handling for failed autonomous jobs

---

## 12. Sources & Further Reading

Key resources used in this analysis:

- [Claude Code: Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Claude Code vs Cursor: Deep Comparison for Dev Teams](https://www.qodo.ai/blog/claude-code-vs-cursor/)
- [Cursor vs Claude Code: The Ultimate Comparison Guide](https://www.builder.io/blog/cursor-vs-claude-code)
- [Understanding Claude Code's Full Stack: MCP, Skills, Subagents, and Hooks](https://alexop.dev/posts/understanding-claude-code-full-stack/)
- [Taming Claude YOLO Mode with Safety Hooks](https://www.the-agentic-engineer.com/blog/2025-10-13-taming-claude-yolo-mode)
- [Cursor Security: Key Risks, Protections & Best Practices](https://www.reco.ai/learn/cursor-security)
- [Critical RCE Vulnerability in Cursor IDE Exposed](https://blog.checkpoint.com/research/cursor-ide-persistent-code-execution-via-mcp-trust-bypass/)
- [Making Claude Code more secure and autonomous](https://www.anthropic.com/engineering/claude-code-sandboxing)
- [Security - Claude Code Docs](https://code.claude.com/docs/en/security)
- [Cursor Documentation: Model Context Protocol](https://docs.cursor.com/context/model-context-protocol)
- [Add MCP Servers to Claude Code - Setup & Configuration Guide](https://mcpcat.io/guides/adding-an-mcp-server-to-claude-code/)
- [Claude Code SDK: Building Agents](https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk)
