#!/usr/bin/env python3
"""PreToolUse gate on outbound Slack messages.

Checks the three mechanically-checkable rules from CLAUDE.md's outbound gate: the ~600-char
cap, PR/ticket mentions that carry no URL, and repeat nudges to the same person. On a
violation it returns the JSON "ask" form so the REASON LANDS IN THE MODEL'S CONTEXT -- a hook
that writes to stderr and exits 0 sends its text to the terminal and the model never sees it
(that failure happened here on 2026-08-13 with the coord guard).

Silent (exit 0, no output) when the message is compliant, when the tool is not a Slack send,
or when anything about the input is unparseable: a gate that blocks on its own bug is worse
than one that misses.

Self-test: `outbound-gate.py --selftest` runs the comparator in both directions.
"""
import json
import os
import re
import sys
from datetime import datetime, timedelta, timezone

CAP_CHARS = 600
CADENCE_HOURS = 20
STATE = os.path.expanduser("~/.claude/state/outbound-sends.jsonl")
TOOLS = {"mcp__slack-post__conversations_add_message", "mcp__slack__conversations_add_message"}
PR_MENTION = re.compile(r"\b(?:core|common|webapp|ops|nils-agent)#\d+", re.I)
PR_NUMBER = re.compile(r"\b((?:core|common|webapp|ops|nils-agent)#\d+)", re.I)
URL_IN_TEXT = re.compile(r"https?://")


def load_sends(channel):
    out = []
    try:
        with open(STATE) as fh:
            for line in fh:
                try:
                    rec = json.loads(line)
                except ValueError:
                    continue
                if rec.get("channel") == channel:
                    out.append(rec)
    except OSError:
        return []
    return out


def check(text, channel, now=None):
    """Return a list of violation strings. Empty list means compliant."""
    now = now or datetime.now(timezone.utc)
    bad = []

    if len(text) > CAP_CHARS:
        bad.append(
            f"RULE 4 (CAP): {len(text)} chars, over the ~{CAP_CHARS} cap. Move the excess onto "
            f"the PR or ticket and link it."
        )

    mentions = set(m.group(1).lower() for m in PR_NUMBER.finditer(text))
    if mentions and not URL_IN_TEXT.search(text):
        named = ", ".join(sorted(mentions))
        bad.append(
            f"RULE 3 (LINK, DON'T EXPLAIN): names {named} with no URL. Every PR/ticket named "
            f"carries its bare URL."
        )

    prior = load_sends(channel)
    if prior:
        last = prior[-1]
        try:
            when = datetime.fromisoformat(last["at"].replace("Z", "+00:00"))
        except (KeyError, ValueError):
            when = None
        if when and now - when < timedelta(hours=CADENCE_HOURS):
            hours = (now - when).total_seconds() / 3600.0
            bad.append(
                f"RULE 7 (CADENCE): last unprompted message to this channel was {hours:.1f}h ago "
                f"(<{CADENCE_HOURS}h). A repeat needs new state or their reply first."
            )
        if set(last.get("mentions") or []) and set(last.get("mentions") or []) == mentions:
            bad.append(
                "RULE 1 (NEW INFO): same PR set as the previous message to this person. If the "
                "recipient already has every fact, do not send."
            )
    return bad


def record(text, channel, now=None):
    now = now or datetime.now(timezone.utc)
    rec = {
        "at": now.isoformat().replace("+00:00", "Z"),
        "channel": channel,
        "chars": len(text),
        "mentions": sorted(set(m.group(1).lower() for m in PR_NUMBER.finditer(text))),
    }
    os.makedirs(os.path.dirname(STATE), exist_ok=True)
    with open(STATE, "a") as fh:
        fh.write(json.dumps(rec) + "\n")


def selftest():
    """Null-test in BOTH directions: a compliant draft must be silent, a bad one must speak."""
    ok = "Morning - https://github.com/nilus-team/core/pull/15792 needs your approval, CI green."
    fails = check(ok, "__selftest_never_used__")
    print("A) compliant draft ->", "SILENT (correct)" if not fails else f"SPOKE (BROKEN): {fails}")
    bad = "core#15792 and core#15793 are waiting on you. " + ("padding. " * 80)
    spoke = check(bad, "__selftest_never_used__")
    print("B) over-cap, no URL ->", f"SPOKE (correct): {len(spoke)} violation(s)" if spoke else "SILENT (BROKEN)")
    for v in spoke:
        print("     -", v)
    return 0 if (not fails and len(spoke) >= 2) else 1


def main():
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    try:
        payload = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    if payload.get("tool_name") not in TOOLS:
        sys.exit(0)
    ti = payload.get("tool_input") or {}
    text = ti.get("text") or ""
    channel = ti.get("channel_id") or ""
    if not text or not channel:
        sys.exit(0)

    violations = check(text, channel)
    if not violations:
        record(text, channel)
        sys.exit(0)

    reason = "Outbound gate (CLAUDE.md 'Outbound messages'):\n" + "\n".join(f"- {v}" for v in violations)
    reason += "\n\nRewrite to comply, or send anyway if this is a correction (rule 8 is exempt from cadence)."
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "ask",
            "permissionDecisionReason": reason,
        }
    }))
    sys.exit(0)


if __name__ == "__main__":
    main()
