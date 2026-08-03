---
description: Watch a Slack DM/thread for a specific person's reply and ping Boris when it lands, via a durable background cron — walk away, it keeps polling for up to 72h. Usage: /watch-slack-reply <Name> [channel_id] [thread_ts]
argument-hint: <Name> [channel_id] [thread_ts]
---

# /watch-slack-reply — background Slack reply watcher

Registers a watcher for `$ARGUMENTS` (target person, optionally with an
explicit channel id / thread ts) that pings Boris in Slack the moment they
reply, or after 72h with no reply. The actual polling happens in a **separate
`CronCreate` job, not this session** — once set up you can close this window
and it still fires.

Full design doc, state file field reference, and the MCP-only-tools
constraint live in `skills/watch-slack-reply/SKILL.md` — read it once if
anything below is unclear, don't re-derive the design.

**Hard rule, repeated because it matters:** all Slack reads/posts go through
`mcp__slack__*` / `mcp__slack-post__*` MCP tools only. Never touch the raw
Slack browser-session tokens in `~/.claude.json`, even though they exist and
even though bypassing MCP would be cheaper. That door stays closed.

## Do this (creation flow — runs once, in this session)

1. **Parse `$ARGUMENTS`**: first token is the target person's name. If a
   channel id and/or thread ts are also given, use them. Otherwise infer
   `channel_id` (and `thread_ts`, if this is a thread reply rather than a
   plain DM) from the conversation Boris is currently looking at. If that's
   ambiguous, ask — don't guess which DM/thread.

2. **Resolve `target_user_id`.** If the name already maps to a known user id
   in context, use it. Otherwise call `mcp__slack__users_search` for the
   name and confirm the match if there's more than one hit.

3. **Resolve `notify_user_id`** (Boris's own Slack user id) the same way —
   `mcp__slack__users_search` for "Boris Churzin" — unless it's already
   known in context. *(Design gap: the original spec assumes this is
   "already known" but doesn't say how. Resolving it via `users_search` each
   time is the reasonable default; once Boris's Slack user id is confirmed
   once, it's worth hardcoding as a constant here to skip the lookup —
   flagged, not done pre-emptively to avoid committing a fabricated id.)*

4. **Write the initial state file:**
   ```bash
   python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py init \
     --channel-id "<channel_id>" \
     --target-user-id "<target_user_id>" \
     --target-name "<Name>" \
     --notify-user-id "<notify_user_id>" \
     [--thread-ts "<thread_ts>"] \
     [--ttl-hours 72]
   ```
   This prints `{"slug": ..., "path": ..., "state": {...}}`. Keep the `slug`.

5. **Load the cron tools.** `CronCreate` is a deferred tool — call
   `ToolSearch` with query `select:CronCreate,CronList,CronDelete` before
   using it.

6. **Create the recurring tick job:**
   - `cron_expression`: `"*/10 * * * *"` (every 10 minutes; `"10m"` shorthand
     is equivalent if you'd rather use that).
   - `durable`: `true` — **required**, not optional. `false` (the default)
     dies the moment this session ends, defeating the entire point of this
     command. See SKILL.md "Durability" section for why.
   - `prompt`: the exact template in **Tick prompt template** below, with
     `<SLUG>` replaced by the slug from step 4.

7. **Record the job id.** `CronCreate` returns a job id — persist it onto the
   state file so the tick can self-delete its own job later:
   ```bash
   python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py set-cron-id <slug> <job_id>
   ```

8. **Confirm to Boris**, one line: who/where is being watched, that it polls
   every ~10 min for up to 72h, and how to cancel early (`CronDelete
   <job_id>`, or `scripts/watch_slack_reply.py cancel <slug>` plus the
   `CronDelete` call — the script alone can't call `CronDelete`, only an
   agent turn can).

## Tick prompt template (the recurring job's `prompt`, verbatim)

This is what actually fires every ~10 minutes. It is fully self-contained —
the tick has no memory of the session that created it, so everything it
needs (slug, and via the state file: channel/thread/target/TTL) must be
derivable from the slug alone.

```
[watch-slack-reply tick] slug=<SLUG>

1. Run `python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py show <SLUG>`.
   If it errors (already completed or missing), stop — nothing to do, do not retry.
2. Run `python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py ttl-check <SLUG>`.
   Note whether `expired` is true, but keep going — a reply found this tick
   still wins even past TTL.
3. Fetch candidate new messages:
   - If the state's `thread_ts` is set: call `mcp__slack__conversations_replies`
     with channel=`channel_id`, ts=`thread_ts`.
   - Else: call `mcp__slack__conversations_history` with channel=`channel_id`,
     oldest=`last_seen_ts`.
   From the results, keep only messages where `user` == the state's
   `target_user_id` AND `ts` is strictly newer than `last_seen_ts`. If more
   than one matches, take the earliest.
4. If a matching message was found:
   a. Build a short snippet: first ~200 chars of its `text`.
   b. If a permalink tool is available, fetch a permalink for it; otherwise
      omit — don't block on this.
   c. Post via `mcp__slack-post__conversations_add_message` — identity is the
      `boris-ai` app, NEVER post as Boris and NEVER as "nils":
      - channel: the state's `channel_id`
      - thread_ts: the state's `thread_ts` if set, else omit (plain DM message)
      - content_type: "text/plain" (preserves newlines; markdown mode mangles
        links and collapses newlines — see commands/voice-slack.md)
      - text: `<@NOTIFY_USER_ID> TARGET_NAME replied: "SNIPPET" PERMALINK_OR_EMPTY`
   d. Run `python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py complete <SLUG> --reason found`.
   e. Call `CronDelete` with the state's `cron_job_id` so this job never fires again.
   f. Stop.
5. Else, if step 2 said `expired: true`:
   a. Post via `mcp__slack-post__conversations_add_message` (same identity/
      content_type rules as 4c) to the state's `channel_id` (and `thread_ts`
      if set):
      text: `<@NOTIFY_USER_ID> no reply from TARGET_NAME after N hours, watcher expired.`
      (N = the `hours_elapsed` or `ttl_hours` value from step 2, rounded.)
   b. Run `python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py complete <SLUG> --reason expired`.
   c. Call `CronDelete` with the state's `cron_job_id`.
   d. Stop.
6. Else (no match, not expired): run
   `python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py advance-last-seen <SLUG>`
   and stop. No Slack post, no cron changes — just advance the watermark so
   next tick doesn't re-scan the same window.
```

## Manual cancel

`python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py cancel <slug>`
moves the state file to `done/` with `completed_reason: "cancelled"`, then
prints the `cron_job_id` so you (or the current agent session) can call
`CronDelete` on it — the script itself has no access to Claude Code tools.

## List active watchers

`python3 ~/.claude/skills/watch-slack-reply/scripts/watch_slack_reply.py list`
