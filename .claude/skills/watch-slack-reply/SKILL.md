---
name: watch-slack-reply
description: Background watcher that polls a Slack DM/thread for a specific person's reply and pings Boris when it lands (or after a 72h TTL). Entry point is the /watch-slack-reply command.
user-invocable: false
---

# watch-slack-reply — background Slack reply watcher

Lets Boris say "watch for Oleg's reply in this DM/thread" and walk away. A
durable Claude Code cron job (`CronCreate`), independent of the session that
created it, polls every 10 minutes and posts a Slack ping the moment a new
message from the target person shows up — or, if 72 hours pass with no
reply, posts a one-line "expired" notice instead.

Entry point: `/watch-slack-reply` (see `commands/watch-slack-reply.md`). This
directory holds the design doc (this file) and the deterministic state
helper the command and the recurring tick both call into.

## Why a script instead of re-deriving logic every tick

Every 10-minute tick is a fresh agent invocation with no memory of the
watcher's creation. `scripts/watch_slack_reply.py` owns everything that
doesn't need an LLM — reading/writing the state file, TTL math, moving a
completed watcher to `done/` — so each tick only has to reason about one
thing: "did the target person post a new message?" That's also the one part
that genuinely needs an agent turn, since it requires calling Slack MCP
tools.

## State file

`~/.claude/watchers/<slug>.json` while active, moved to
`~/.claude/watchers/done/<slug>.json` on completion (reply found, TTL
expiry, or manual cancel via `scripts/watch_slack_reply.py cancel <slug>`).

`<slug>` is `<target-name-slug>-<YYYY-MM-DD>` (e.g. `oleg-2026-08-03`), deduped
with `-2`, `-3`, ... on same-day collisions — readable, not a UUID.

| Field             | Type          | Notes                                                          |
|-------------------|---------------|-----------------------------------------------------------------|
| `channel_id`      | string        | DM or channel id containing the conversation.                   |
| `thread_ts`       | string \| null| Set for a thread watcher; `null` for a plain DM.                 |
| `target_user_id`  | string        | Slack user id of the person being watched.                       |
| `target_name`     | string        | Human-readable name (e.g. `"Oleg"`), used in notify text and slug.|
| `last_seen_ts`    | string        | Slack ts (epoch seconds, 6 decimals). Only messages newer than this count as "new". |
| `created_at`      | string        | Slack ts at watcher creation. Basis for the TTL check.           |
| `ttl_hours`        | number        | Default `72`. After this many hours with no match, the watcher expires. |
| `notify_user_id`  | string        | Boris's Slack user id — who gets `<@...>`-tagged in the ping.    |
| `cron_job_id`     | string \| null| The `CronCreate` job id, set once via `set-cron-id` right after creation. Lets a tick self-delete its own job. |
| `completed_at`    | string        | Added on completion only.                                        |
| `completed_reason`| string        | `found` \| `expired` \| `cancelled`. Added on completion only.   |

## 72h TTL and self-cleanup

Every tick calls `scripts/watch_slack_reply.py ttl-check <slug>` before doing
anything else. If `created_at` is more than `ttl_hours` (default 72) in the
past **and** no new message was found this tick, the tick posts a one-line
"no reply from `<target_name>` after `<N>` hours, watcher expired" message,
moves the state file to `done/` via `complete --reason expired`, and calls
`CronDelete` on its own `cron_job_id`. A reply found within the TTL window
takes priority and short-circuits the expiry path in the same tick.

Separately, Claude Code's own cron scheduler auto-expires *any* recurring
job after 7 days regardless of what the job's prompt does. That's well
outside our 72h default, so it's not normally reachable — it only matters if
someone raises `ttl_hours` past a week, in which case the platform cap wins
silently before our own TTL logic ever fires. Keep `ttl_hours` well under 7
days.

## Durability — why `durable: true` on CronCreate

`CronCreate`'s `durable` flag defaults to `false`: an in-memory job that dies
the moment the creating session ends. This watcher's whole point is to
outlive the session that created it, so the command always passes
`durable: true`, which persists the job to `.claude/scheduled_tasks.json` and
lets it fire from a background process rather than the specific terminal
window Boris was typing in when he ran `/watch-slack-reply`.

## Hard constraint: MCP tools only, never raw tokens

All Slack access — both reading history/replies and posting the notification
— must go through the existing `mcp__slack__*` (read) and `mcp__slack-post__*`
(post) MCP tools. Do not read, derive, or reference raw Slack browser-session
tokens for this watcher, in code, comments, commit messages, or anywhere
else — the MCP tool boundary is the sanctioned, permissioned path and stays
that way even if bypassing it would be cheaper. If a future change wants to
"optimize" this by hitting the Slack API directly, that's the wrong call —
extend the MCP server instead.

## Posting identity

Notifications post via `mcp__slack-post__conversations_add_message` under
the `boris-ai` app identity — never as Boris himself and never as the `nils`
bot (`U0ACWRM68FJ`, see `skills/review-followup-slack/SKILL.md` for why that
identity is already overloaded). Use `content_type: "text/plain"` — Slack's
`text/markdown` mode collapses newlines and mangles links (see
`commands/voice-slack.md` for the empirically-verified delivery quirks).
