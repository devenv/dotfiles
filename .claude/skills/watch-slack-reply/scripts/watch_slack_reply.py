#!/usr/bin/env python3
"""Deterministic state management for the watch-slack-reply skill.

Owns everything that does NOT need an LLM: writing/reading the watcher state
file, TTL math, and moving a watcher to done/ on completion. It never talks
to Slack itself — the /watch-slack-reply command (creation) and the CronCreate
tick prompt (polling) own all Slack MCP tool calls and call this script only
for the bookkeeping around them.

State file convention: ~/.claude/watchers/<slug>.json while active, moved to
~/.claude/watchers/done/<slug>.json on completion (reply found, TTL expiry,
or manual cancel). See skills/watch-slack-reply/SKILL.md for the full field
reference and design notes.

No network calls, no Slack MCP calls, no secrets. Reads/writes local JSON
files only.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path

WATCHERS_DIR = Path.home() / ".claude" / "watchers"
DONE_DIR = WATCHERS_DIR / "done"
DEFAULT_TTL_HOURS = 72


def _now_slack_ts() -> str:
    """Current time as a Slack-style ts string (epoch seconds, 6 decimals)."""
    return f"{time.time():.6f}"


def _slugify(name: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", name.strip().lower()).strip("-")
    return slug or "watcher"


def _slug_for(target_name: str) -> str:
    """<target-name-slug>-<YYYY-MM-DD>, deduped with -2, -3, ... on collision."""
    date_part = time.strftime("%Y-%m-%d", time.gmtime())
    base = f"{_slugify(target_name)}-{date_part}"
    WATCHERS_DIR.mkdir(parents=True, exist_ok=True)
    candidate = base
    n = 2
    existing = {p.stem for p in WATCHERS_DIR.glob("*.json")}
    while candidate in existing:
        candidate = f"{base}-{n}"
        n += 1
    return candidate


def _active_path(slug: str) -> Path:
    return WATCHERS_DIR / f"{slug}.json"


def _load_active(slug: str) -> dict:
    path = _active_path(slug)
    if not path.exists():
        done_path = DONE_DIR / f"{slug}.json"
        if done_path.exists():
            raise SystemExit(
                f"watcher '{slug}' is already done (see {done_path}) — nothing to do."
            )
        raise SystemExit(f"no active watcher state file at {path}")
    return json.loads(path.read_text())


def _save_active(slug: str, state: dict) -> None:
    _active_path(slug).write_text(json.dumps(state, indent=2) + "\n")


def cmd_init(args: argparse.Namespace) -> None:
    slug = _slug_for(args.target_name)
    now = _now_slack_ts()
    state = {
        "channel_id": args.channel_id,
        "thread_ts": args.thread_ts,
        "target_user_id": args.target_user_id,
        "target_name": args.target_name,
        "last_seen_ts": args.last_seen_ts or now,
        "created_at": now,
        "ttl_hours": args.ttl_hours,
        "notify_user_id": args.notify_user_id,
        "cron_job_id": None,
    }
    _save_active(slug, state)
    print(json.dumps({"slug": slug, "path": str(_active_path(slug)), "state": state}, indent=2))


def cmd_show(args: argparse.Namespace) -> None:
    print(json.dumps(_load_active(args.slug), indent=2))


def cmd_set_cron_id(args: argparse.Namespace) -> None:
    state = _load_active(args.slug)
    state["cron_job_id"] = args.cron_job_id
    _save_active(args.slug, state)
    print(json.dumps(state, indent=2))


def cmd_advance_last_seen(args: argparse.Namespace) -> None:
    state = _load_active(args.slug)
    state["last_seen_ts"] = args.ts or _now_slack_ts()
    _save_active(args.slug, state)
    print(json.dumps(state, indent=2))


def cmd_ttl_check(args: argparse.Namespace) -> None:
    state = _load_active(args.slug)
    created_at = float(state["created_at"])
    ttl_hours = float(state.get("ttl_hours") or DEFAULT_TTL_HOURS)
    hours_elapsed = (time.time() - created_at) / 3600.0
    print(
        json.dumps(
            {
                "expired": hours_elapsed >= ttl_hours,
                "hours_elapsed": round(hours_elapsed, 2),
                "ttl_hours": ttl_hours,
            },
            indent=2,
        )
    )


def cmd_complete(args: argparse.Namespace) -> None:
    state = _load_active(args.slug)
    state["completed_at"] = _now_slack_ts()
    state["completed_reason"] = args.reason
    DONE_DIR.mkdir(parents=True, exist_ok=True)
    (DONE_DIR / f"{args.slug}.json").write_text(json.dumps(state, indent=2) + "\n")
    _active_path(args.slug).unlink()
    print(json.dumps(state, indent=2))


def cmd_list(_args: argparse.Namespace) -> None:
    WATCHERS_DIR.mkdir(parents=True, exist_ok=True)
    rows = []
    for path in sorted(WATCHERS_DIR.glob("*.json")):
        state = json.loads(path.read_text())
        rows.append(
            {
                "slug": path.stem,
                "target_name": state.get("target_name"),
                "channel_id": state.get("channel_id"),
                "thread_ts": state.get("thread_ts"),
                "created_at": state.get("created_at"),
                "ttl_hours": state.get("ttl_hours"),
                "cron_job_id": state.get("cron_job_id"),
            }
        )
    print(json.dumps(rows, indent=2))


def cmd_cancel(args: argparse.Namespace) -> None:
    state = _load_active(args.slug)
    cron_job_id = state.get("cron_job_id")
    cmd_complete(argparse.Namespace(slug=args.slug, reason="cancelled"))
    if cron_job_id:
        print(
            f"NOTE: this script cannot call CronDelete itself — from an agent session, "
            f"call CronDelete with job id '{cron_job_id}' to stop the recurring tick.",
            file=sys.stderr,
        )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("init", help="Create a new active watcher state file.")
    p.add_argument("--channel-id", required=True)
    p.add_argument("--target-user-id", required=True)
    p.add_argument("--target-name", required=True)
    p.add_argument("--notify-user-id", required=True)
    p.add_argument("--thread-ts", default=None, help="Omit for a plain DM watcher.")
    p.add_argument("--ttl-hours", type=float, default=DEFAULT_TTL_HOURS)
    p.add_argument(
        "--last-seen-ts",
        default=None,
        help="Slack ts to start watching after. Defaults to now.",
    )
    p.set_defaults(func=cmd_init)

    p = sub.add_parser("show", help="Print an active watcher's state.")
    p.add_argument("slug")
    p.set_defaults(func=cmd_show)

    p = sub.add_parser("set-cron-id", help="Record the CronCreate job id on the state file.")
    p.add_argument("slug")
    p.add_argument("cron_job_id")
    p.set_defaults(func=cmd_set_cron_id)

    p = sub.add_parser("advance-last-seen", help="Bump last_seen_ts (default: now).")
    p.add_argument("slug")
    p.add_argument("--ts", default=None)
    p.set_defaults(func=cmd_advance_last_seen)

    p = sub.add_parser("ttl-check", help="Report whether the watcher has passed its TTL.")
    p.add_argument("slug")
    p.set_defaults(func=cmd_ttl_check)

    p = sub.add_parser("complete", help="Move a watcher to done/ with a completion reason.")
    p.add_argument("slug")
    p.add_argument("--reason", required=True, choices=["found", "expired", "cancelled"])
    p.set_defaults(func=cmd_complete)

    p = sub.add_parser("list", help="List all active watchers.")
    p.set_defaults(func=cmd_list)

    p = sub.add_parser("cancel", help="Manually cancel an active watcher (reason=cancelled).")
    p.add_argument("slug")
    p.set_defaults(func=cmd_cancel)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
