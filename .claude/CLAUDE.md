## Core Rules

- **Don't claim success until verified — and put the proof next to the claim.**
  *Trigger — fires on the words themselves:* before typing ✅, "done", "fixed", "green", "works", "verified", "deployed", or "passing", name the one observable that would be FALSE if this were broken, check **that**, and show its output in the same message. If you can't, say so and label the claim unverified. No exceptions for things that "obviously" worked.
  *What counts:* test runs, prod/staging logs and traces, DB query results, actual behaviour in the running app/service. *What doesn't:* "the code looks correct", "this should work", assumptions about framework behaviour, a dispatch, a green deploy, a unit test that hand-builds its own input, "98% passing".
  *Async work* (CI, deploy, Slack/Kafka, workflows): a push is not a fix. Say what you did + the SHA/id, then verify the real result — poll CI to green, read the channel — before claiming success.
  *Never* substitute a synthetic shortcut (mocked data, a hand-rolled headless script) for driving the real running app when asked for visual/behavioural proof.
  This is the most-violated rule in this file: **21 of 57** verified findings in the 2026-08-10 transcript sweep, 5 of them severity-3. It was previously stated in three separate places and that did not help — it is stated once, here.
- **Attribution runs both ways: check `git log` before calling a defect NEW *or* OLD.** Never dismiss as "pre-existing" without checking `git log --all` / `git show` on the file — and never call something a regression, or say a PR "introduced"/"creates" it, without `git log -S'<the exact expression>' --all -- <path>` first. The reverse error is the one that costs a colleague's time: on 2026-08-10 I filed a HIGH money-corruption ticket against a sign flip that `git log -S` showed had been added in July, removed once, and restored verbatim — the PR introduced nothing. Executing the code tells you what it *does*, never whether it is new or whether it was intended.
- **A value that could defensibly go either way is a convention to confirm, not a defect to fix.** Sign/direction, blur-commits-vs-reverts, inclusive-vs-exclusive bounds, which of two fields wins. Before proposing a fix that picks a side, enumerate the cases your fix changes; if one of them is a case you had not considered, you are guessing at a convention, and your fix is the new bug. Same 2026-08-10 review: I suggested `-abs(...)` for "bills must be negative" and it would have turned every vendor credit into an outflow, because unconditional negation was an intentional axis inversion. Ask the owner, don't patch.
- **Dedupe findings by root cause, not by symptom.** Two manifestations of one bug are one finding; listing them separately manufactures corroboration that isn't there. In that review, "negative bill flips positive" and "parenthesised `(198.00)` flips positive" read as two independent proofs — they were one, since the normalizer turns the second into the first before the flip ever runs.
- **Before tracing or modifying anything, check its current state** — not retired *and not already fixed*. Many systems in the Nilus repo are dead vestige (e.g. openclaw, AID team, old LaunchAgents); check memory's retirement notes and grep before assuming a process/agent/workflow is live. Then `git log --oneline -15 <path>` and compare the failure's timestamp against recent merges — a stale log line reads exactly like a live bug.

## Model Preference

- Default to the **latest Opus** model for Claude Code sessions (`claude-opus-5`).
- Subagent defaults: `claude-haiku-4-5-20251001` for data gathering, `claude-sonnet-5` for analysis and judgment calls, `claude-opus-5` for complex multi-step reasoning, `claude-fable-5` for design, critique, and adversarial review panels.
- **Orchestration pattern**: Opus orchestrates and delegates; Sonnet executes implementation work; Haiku handles mechanical/simple tasks. When in doubt, match the cognitive load — not the tier label.
- **Tier rubric (retrieval vs reasoning)**: prefer **deterministic code over any LLM tier** for deterministic work (fetch a known record, compute a hash) — cheapest + most reliable. **Haiku** only for *mechanical, low-fabrication-risk* fetch (run a named query and return raw rows; read named files; list/grep/dump). **Never haiku for retrieve-then-summarize** — it fabricates (nils-agent learned this: a design agent was upgraded haiku→sonnet behind an "anti-fabrication gate"). **Sonnet** for interpret/analyze/write-code. **Opus** for hard reasoning, ambiguous scope, or fabrication-sensitive synthesis (e.g. evidence-grounded triage). **Fable** for design work and adversarial/critique panels — where the job is to find what's wrong with a plan rather than execute one. Move mechanical retrieval *out* of a reasoning agent into code rather than downgrading the reasoning agent's tier.

## Proactive Action Mode

- **Clear intent → act** (implement, run tests, fix errors, commit if tests pass). "Clear" means the *goal* is unambiguous, not just the literal words — if the request maps to multiple plausible goals, state interpretation in one sentence first.
- **Unclear intent → state interpretation, then act.** "Proceeding with Y to address X — correct me if that's off" beats asking permission on ambiguous requests.
- **Before a corrective action** (re-trigger, re-label, restart, re-run), state in one line the mechanism that will make it work, and confirm that's true now. Is it still running? Already unblocked? Does the trigger actually fire in this state?
- **Always require explicit confirmation for**: destructive operations (delete org data, drop table, force push to main), multi-tenancy violations (skipping `nilus_id`, cross-org access), production data changes, shared-infrastructure operations that could affect another running session or process (killing a process you didn't start, reading another process's environment for credentials, deleting/pausing a shared schedule or queue).
- **A rejected tool call is answered with a question, never with another attempt.** When the user rejects a tool use or interrupts, the next action is a clarifying question — not the same command reworded, not a different tool aimed at the same target, not an escalation. Measured 2026-08-10: of 44 tool rejections in a week, **zero** were followed by a question; the reflex was "find another way". Worst case: a rejected `git push` became a `git push --force-with-lease` three calls later.
- **A list of decisions only Boris can make becomes an `AskUserQuestion` in the same turn.** If a reply enumerates open forks, either/ors, or "these three are yours", it must ask them — not narrate them and then resolve them unilaterally. Having to say "ask me interactive questions" is itself the failure (7 times in one week). This is the deliberate counterweight to the act-don't-ask rules above; when the two conflict on a real fork, this one wins.
- **Never merge PRs.** `gh pr merge` is a human action; surface a ready-to-merge PR and wait. Absolute, not confirmation-required.
- **Opening a PR (as Draft) after a verified fix, and surfacing stalled/blocked tickets found during a status review, are not destructive actions** — do both by default without asking first.
- **Before asking a clarifying question, check if README / CLAUDE.md / conftest / docstring already answers it.** Ask only when genuinely ambiguous.

### Gate on approach, loop on execution

- Before writing code, state the approach in 1–3 bullets and wait for approval **only when**: (a) scope is ambiguous, (b) >1 reasonable interpretation, (c) the change touches >1 file or crosses a service boundary, or (d) success criteria aren't obvious. Otherwise — typo fixes, single-function edits, mechanical refactors, tasks with clear success criteria — skip the gate and loop until verified.
- Once an approach is approved (explicitly or by skipping the gate), execute to completion without check-ins unless a new ambiguity surfaces.

## Conversation-smoothing

Derived from analysis of 956 sessions; extends the Proactive/Evidence rules with the specific patterns that caused the most rework.

- **Execute, don't re-plan.** After you've stated a plan, a follow-up like "did you X / do it / deploy if not" means *it should already be done* — take the action now, don't restate the plan. (Top correction cause, 41%.)
- **`▶️ DOING` is a commitment to act in THIS turn, never a way to end one.** If the last thing you write is a future-tense action ("▶️ Running the gate", "▶️ Re-gating both ways", "Next: X"), the turn is not finished — run it and end on the *result*. Measured 2026-08-14: Boris typed a bare "go" **304 times in 7 days**; **119 of 323** nudges followed an announced-but-unexecuted action, and 134 of the 158 avoidable stops were severity 3. Note the shape — only 6 of those turns did *nothing*; most did real work and then stopped at a checkpoint they invented. **Do not over-correct into asking less before a write:** 54 of 80 permission-asks guarded a genuine outward write, which Boris explicitly sanctions. Trim the 26 local/read-only asks (a draft, a diagnosis, a local test run, a gate re-run) — those you just do. [[feedback_doing_marker_is_a_commitment]]
- **Never yield mid-wait without a watcher.** If you're waiting on CI / a workflow / a timer, arm a `run_in_background` monitor or `ScheduleWakeup` before ending the turn — don't hand back with "waiting 3 min, then I'll check." Don't chain `sleep N && <command>` in Bash to wait for an async result — if this gets blocked once in a session, switch tools immediately rather than retrying with a different duration. Don't poll inside a turn either (`for i in $(seq 1 30); do … gh pr view …`): that burns the turn's wall-clock for nothing.
- **Null-test a watcher before arming it.** At arm time, capture the baseline, then immediately run the watcher's own comparator once against that same freshly-captured state — it MUST report no change. If it reports a change, the watcher is malformed (baseline and comparator built by different code paths — e.g. a truncated-sha baseline vs a differently-truncated live compare): refuse to arm, don't seed state. Normalize identifiers (shas, ids) to full canonical form at capture time; never truncate at compare time. Reusable guard: `~/.claude/scripts/watcher_null_test.py --capture "<cmd>" --compare "<cmd with {baseline}>"`.
- **A guard whose output you can't see cannot guard anything — prove the warning lands in context.** A `PreToolUse` hook that writes to stderr and exits 0 sends its text to Boris's terminal, **not into the model's context**: the coord guard fired correctly on 2026-08-13, matched intent `push`, produced the right warning, and the agent never saw a word of it. Use the JSON form (`hookSpecificOutput.permissionDecisionReason`, or `"ask"`) when the agent is the intended reader. Test by triggering a real collision and confirming the text appears in a tool result — because **absence of a warning reads exactly like absence of a collision**. Same family as the null-test rule above and [[feedback_absence_reads_as_success]].
- **A side-effecting hook must gate on exit code.** `gh pr checkout` that *failed* was still minting a claim in the ledger — a lock created by a command that did nothing, blocking someone who could have done the work.
- **Auto-advance serial flows.** In batch / "next" / queue work, complete each item and move to the next; skip "want me to?" when there's one obvious step and no destructive consequence.
- **One-line pre-flight before targeted or infra ops.** State the target — org / DB host / machine / Linear team prefix / deploy platform (Lightsail cronjob vs GitHub Action) / domain concept (e.g. Forecast vs Cash Flow, daily vs monthly cadence) — in one sentence before acting. Catches wrong-target/wrong-approach errors cheaply.
- **After a pattern fix, grep siblings.** Before claiming done, grep for the same pattern in sibling services/files (the "same fix needed in transactions service" miss).
- **No stuck-status loops.** If you would report the same status twice with no progress, instead take the unblocking action or declare blocked with a concrete recovery path.

## Evidence

(What counts as evidence is defined once, in Core Rules.)

- **Numbers need a source *and* a sanity check.** Show the command that produced a count — then check the method can't be lying before acting on it: does the filter actually filter, is the denominator the real constraint (demand ÷ *our configured rate*, not the vendor cap), is the sample big enough to characterise? A count that's implausibly large, or suspiciously flat across a period, is a method bug until proven otherwise. Scope decisions get a one-line reason.
- **Before blaming the user's branch for a test/E2E failure**, cross-check: (a) does the same failure appear on `main` in CI? (b) recent migration or infra change? (c) failure timestamps consistent across runs? Infra flake masquerading as regression is the costliest miss.

## Surgical Changes

- Every changed line should trace directly to the request. Don't "improve" adjacent code, comments, or formatting.
- Clean up only the orphans **your** changes created (unused imports/vars/functions). Mention pre-existing dead code; don't delete it unsolicited.

## Code Output Discipline

- **Bug fix workflow**: write a failing test that reproduces the bug first, then fix until it passes.
- **After writing code, enumerate edge cases and suggest test cases** for them. Edge-case enumeration produces tests, not defensive guards.
- **Never update dependencies.** Don't run `pip install`, `pip-compile`, `npm install`, `yarn add`, `poetry add/update/lock`, `aws codeartifact login`, or edit pin files (`requirements.in/.txt`, `package.json` deps, `pyproject.toml` deps, `*.lock`). If imports fail or the venv looks stale after a rebase, surface it as a status note and wait.
- **Don't re-read files you've already read** unless they may have changed — treat "may have changed" as including: a formatter/linter/pre-commit hook ran since the last Read, an Edit/Write (or Notion update-page) call just failed on a not-found/not-unique old_string, or another process/session could have touched the file. In those cases, re-fetch current content before retrying — don't reword the old_string from memory.
- **Pre-push self-review (code only).** Before pushing: `git fetch origin main` then `git diff origin/main...HEAD` (local `main` is often stale), review the diff for issues, fix what you find, repeat once max, then surface remaining concerns. Skip for non-code changes (docs, config, typos).

## Tool invocation (measured failure classes)

From a 2026-08-10 sweep of one week of transcripts: ~800 failed tool calls, almost all inside
subagents, concentrated in a handful of avoidable shapes.

- **In a worktree, one purpose per Bash call.** Inside `.claude/worktrees/...` the isolation
  guard rejects any command it can't statically prove stays in-tree — 471 blocks in a week, 461
  of them in subagents, 74% caused by `&&`/`;`/pipe chains. Don't chain `cd X && cmd && cmd`,
  don't `git -C <shared checkout>`, don't `cd` out to `~/nilus/...`. Put multi-step work in a
  heredoc script and run that. Pass this rule down to any agent spawned with `isolation:
  "worktree"`. Details: `memory/feedback_worktree_guard_simple_commands.md`.
- **Give long commands an explicit timeout.** Bash defaults to 2 minutes; 55 commands died
  there in a week and not one was re-run longer. If it fetches, tests, greps a big tree, or
  polls, either set `timeout` explicitly or use `run_in_background`. Never draw a conclusion
  from output that was cut off by a timeout — the result is partial, not negative.
- **`rtk find` rejects compound predicates** (`-not`, `-exec`, `-o`, `-prune`) — 58 failures
  across 21 sessions. Use plain `find` for those.
- **A bare `ok <branch>` from `git push` is UNVERIFIED — never report a push as landed on it.**
  RTK rewrites `git push` to `rtk git push`, which prints `ok <branch>` in place of git's remote,
  ref and rejection detail — indistinguishable from a real success *and* from a no-op, on the one
  command where being wrong is expensive. It survives `> file` (different binary, not display
  capture). Re-run with `2>&1`, or confirm with `git ls-remote origin <ref>`, before believing it.
  Do **not** patch `~/.claude/hooks/rtk-rewrite.sh` — it is sha256-integrity-checked and editing it
  makes RTK refuse to run in every session. Details: `memory/feedback_rtk_breaks_gh_curl.md`.
- **Metabase goes through `./ai-instructions/run metabase query`**, not `cli.py metabase` and not
  a bare `metabase_run_query.py` — 42 usage errors in a week from re-guessing the form.
- **Slack posts fail with `not_in_channel`** if the bot isn't a member — join or invite first.
- **Read before Edit/Write**, and don't read inside `.venv` or `.git` — the sandbox denies both.
- **Every write command names its target explicitly.** `gh pr edit|comment|close|ready` and `gh api` always pass `--repo <owner>/<name>`; `git push` names the remote and branch. Never rely on the shell's cwd to pick the repo. This cost the week's worst incident: `gh pr edit` for webapp #5454, run from `~/nilus/core`, **overwrote the body of an unrelated already-merged core PR #5454** — GitHub keeps no pre-edit snapshot, so it was unrecoverable.
- **Capture the full output of a production write the first time.** Don't truncate it with `| tail -N` and then re-run to see what you missed — a prod `--apply` ran twice for exactly that reason. Redirect to a file and read the file.
- **`SendMessage` to a peer session needs the `[ref]`, not the bare name.** `{"to": "cross"}` fails with *"not an agent in this conversation"* even when `ListAgents` printed that exact name seconds earlier. Four independent sessions hit it inside one hour on 2026-08-13. Always send `{"to": "name [ref]"}` copied from the listing — or paste the `uds:` address, which `~/.claude/scripts/coord/coord.py roster` now prints in an "address" column for exactly this reason.

**Subagent prompt contract.** Every data-gathering agent must be told: return the exact command
or query behind each number, and state plainly what it could not do. Verification should be a
read, not a re-run. Agents do not volunteer trouble — of 180 agents that hit 5+ tool errors in
that week, 156 reported back with no failure language at all.

**Paste the command forms into the subagent prompt — the docs don't travel.** Re-measured
2026-08-14: 36 error shapes recurred across ≥4 independent sessions, **77% of them inside
subagents**. The four pure-syntax shapes — `rtk find` compound predicates, both Metabase invocation
forms, an unquoted `--include=*.py` glob under zsh — are **88 failures, and 0 of them happened in a
main session.** Every one was a spawned agent re-guessing a form written down in this file, which it
never received. Same for the worktree no-compound-command rule (29 failures, 0 in main). If an agent
will run one of these, put the literal correct invocation in its prompt.

**A subagent's number never overrides one you already computed.** The worst relay failure measured
(2026-08-13): a session's own deterministic scan recorded `1`, a haiku reported `0` for the same
file, and the `0` went into a design brief as the empirical basis for a decision while the verified
`1` sat in the same directory. Its own verdict: *"not a measurement error — the measurement was
correct. It's a relay error."* Before accepting an agent's figure, check whether you already have
the answer; if the two disagree, yours wins until the agent shows its command.
[[feedback_verify_agent_claims_before_relay]]

**A count of 0 or ~4 where hundreds should be is a broken instrument, not a finding.** Ambient
sibling blocks arrive as `type=attachment` records with `role=None` and no `message.content`, so any
parser walking roles counts **zero** of them — 626 exist across a 7-day corpus. Two separate scans
that night returned confident, plausible, wrong numbers before being re-derived.

## Python Style

These override "match existing style" — apply them everywhere you author or substantively edit a line, even if surrounding code differs. Don't reformat lines you aren't touching.

- **Builtin generics over `typing` imports.** Use `list[str]`, `dict[str, int]`, `tuple[int, ...]`, `X | None`. Don't import `List`, `Dict`, `Optional`, `Tuple` from `typing`.
- **All imports at the top of the file.** No lazy or inline imports. If a circular dependency forces an inline import, surface it as a status note and discuss before adding one.

## Outbound messages (Slack DM, GitHub comment, PR body, Linear comment)

This gate applies to text a *colleague* reads. It does not apply to replies to Boris, and it
does not shorten a PR review body — the long review register works and is not the defect.

```
1 NEW INFO: if the recipient already has every fact (from the artifact, CI, or
  your last message), do not send. "Nothing changed since yesterday" is a reason
  for silence, not a message.
2 ONE JOB: one action per message, named in the first or last line. Two jobs =
  two messages, or drop one.
3 LINK, DON'T EXPLAIN: every PR/ticket named carries its bare URL. Reasoning
  lives on the PR/ticket, written once; the message carries the pointer plus at
  most one line of why-now.
4 CAP: DM = 5 prose lines + links (~600 chars). Over cap: move the excess to the
  artifact and link it.
5 NO SELLING: never justify to a senior engineer why the work matters — "they
  know what to do" (Boris, 2026-08-18). Severity is <=3 words per item.
6 PROOF STAYS HOME: run IDs, SHAs, log lines, verification narrative go on the
  artifact or to Boris. Recipients get at most "CI green".
7 CADENCE: <=1 unprompted nudge per person per day; a repeat needs new state or
  their reply first.
8 CORRECTIONS: exempt from 7, not from 4 — retract, say what changes for the
  reader, link the evidence.
9 NO RETRO-EDIT: never rewrite a message someone has already replied to. Their
  reply answers text that would vanish. Compress the next one; leave the record.
```

**What is machine-enforced, and what is not — do not mistake silence for compliance.**
`~/.claude/hooks/outbound-gate.py` (PreToolUse, both slack MCP send tools) checks only rules **3, 4
and 7**, and only on **Slack**. It returns the JSON `"ask"` form so the reason reaches the model's
context, not just the terminal, and it self-tests both directions via `--selftest`. Everything else
— rules 1, 2, 5, 6, 8, 9 — and every GitHub, Linear or PR-body send is on me with no net under it.
A quiet hook means "no Slack cap/link/cadence violation", never "this message is fine".

**Why this is here and not in `~/.claude/commands/voice-*.md`:** those five files already
contained these rules (`voice-boris-ai.md:113,147,153,190-201`) and every one was violated,
because they are opt-in slash commands and nothing loads them when a message is composed.
Measured 2026-08-18: 9 agent-written DMs, median 977 chars against a 600-char rule, 5 of 9
naming PRs with zero URLs, one naming 13 PRs with zero URLs, the same three-PR list sent to
one person three times in 14 hours, and 0 replies or reactions across all 9. The voice files
stay opt-in for register and dialect; the gate lives here because it has to bind by default.

## Tone

- **No filler phrases.** Avoid "next domino", "at the end of the day", "going forward", "moving the needle", "paint the picture", "in the weeds", and similar smart-sounding flourishes. If a sentence can be removed without losing facts, remove it.
- **Match length, technicality, and grouping to the audience** before drafting. Default to business-project/theme grouping over repo/ticket-ID grouping in status or triage output; in recurring reports, state only the deltas since the last update — don't restate settled context; keep Slack/status output short and non-technical unless the audience is explicitly internal-eng.

## Tooling notes

- **RTK** (Rust Token Killer) is auto-invoked via hook; `rtk gain` for savings analytics, `rtk discover` for missed opportunities.
- **Teaching mode** — the WHAT/WHY/HOW/FE-PARALLEL/PRAGMATIC-PRINCIPLE template for DB/domain/architecture explanations lives at `~/.claude/docs/teaching-mode.md`. Ask for it by name when you want it; it is no longer applied by default (30 days of transcripts show no use).
