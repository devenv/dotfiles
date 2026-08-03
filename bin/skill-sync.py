#!/usr/bin/env python3
"""Sync local .claude/skills/<slug>/SKILL.md changes to Anthropic /v1/skills.

Reads the slug → skill_id map from /tmp/managed-agent-skills-upload/skill-ids.json
(scp'd from lightsail) or a local copy. For each skill, checks if the SOURCE
SKILL.md has changed since the last sync (hash stored in ~/.local/share/skill-sync/hashes.json),
sanitizes (matches setup logic — name → slug, strip XML-like tokens), and pushes
a new version via client.beta.skills.versions.create().

Designed to run nightly via cron on the Mac (sources are local).

Usage:
    skill-sync.py [--dry-run]   # show what would be synced, no API calls

Env:
    ANTHROPIC_API_KEY   required
    SKILL_IDS_PATH      override path to skill-ids.json (default: known locations)
"""
import argparse
import hashlib
import json
import os
import re
import shutil
import sys
import tempfile
from pathlib import Path

from anthropic import Anthropic
from anthropic.lib import files_from_dir

REPO_SKILLS = Path("/Users/devenv/nilus/core/.claude/skills")
HASH_DIR = Path.home() / ".local/share/skill-sync"
HASH_FILE = HASH_DIR / "hashes.json"
DEFAULT_SKILL_IDS_PATHS = [
    Path("/tmp/managed-agent-skills-upload/skill-ids.json"),
    Path.home() / ".local/share/skill-sync/skill-ids.json",
]


def load_skill_ids():
    override = os.environ.get("SKILL_IDS_PATH")
    candidates = [Path(override)] if override else DEFAULT_SKILL_IDS_PATHS
    for p in candidates:
        if p.exists():
            return json.loads(p.read_text()), p
    return {}, None


def sanitize_skill_dir(slug, src_dir, dst_dir):
    """Mirror the upload-time sanitization (matches setup-skills logic).

    - Copy whole tree
    - Rewrite SKILL.md frontmatter: name → slug, description → strip <XML>
    """
    if dst_dir.exists():
        shutil.rmtree(dst_dir)
    shutil.copytree(src_dir, dst_dir)
    sk = dst_dir / "SKILL.md"
    txt = sk.read_text()
    m = re.match(r"^---\n(.*?)\n---", txt, re.DOTALL)
    if not m:
        return
    fm, body_after = m.group(1), txt[m.end():]
    cur_desc = re.search(r"^description:\s*(.+?)(?=\n[a-z_]+:|\Z)", fm, re.MULTILINE | re.DOTALL)
    desc = cur_desc.group(1).strip() if cur_desc else ""
    desc_clean = re.sub(r"<([a-zA-Z0-9_/]+)>", r"[\1]", desc).replace("\n", " ")
    desc_clean = re.sub(r"\s+", " ", desc_clean).strip()
    if len(desc_clean) > 1024:
        desc_clean = desc_clean[:1020] + "..."
    new_fm = f"name: {slug}\ndescription: {desc_clean}"
    sk.write_text(f"---\n{new_fm}\n---{body_after}")


def hash_dir(dirpath):
    """Hash all files in directory deterministically."""
    h = hashlib.sha256()
    for p in sorted(dirpath.rglob("*")):
        if p.is_file():
            h.update(str(p.relative_to(dirpath)).encode())
            h.update(b"\0")
            h.update(p.read_bytes())
            h.update(b"\0")
    return h.hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    skill_ids, src_path = load_skill_ids()
    if not skill_ids:
        sys.stderr.write("ERR: no skill-ids.json found\n")
        sys.exit(1)
    print(f"Loaded {len(skill_ids)} skill IDs from {src_path}")

    HASH_DIR.mkdir(parents=True, exist_ok=True)
    hashes = {}
    if HASH_FILE.exists():
        try:
            hashes = json.loads(HASH_FILE.read_text())
        except Exception:
            hashes = {}

    if not args.dry_run:
        client = Anthropic()  # picks up ANTHROPIC_API_KEY

    updated = []
    skipped = []
    missing = []
    failed = []

    with tempfile.TemporaryDirectory(prefix="skill-sync-") as tmp:
        tmp = Path(tmp)
        for slug, skill_id in sorted(skill_ids.items()):
            src = REPO_SKILLS / slug
            if not src.exists():
                missing.append(slug)
                continue
            staged = tmp / slug
            sanitize_skill_dir(slug, src, staged)
            cur_hash = hash_dir(staged)
            prev_hash = hashes.get(slug)
            if cur_hash == prev_hash:
                skipped.append(slug)
                continue
            if args.dry_run:
                updated.append((slug, "would-sync"))
                hashes[slug] = cur_hash
                continue
            try:
                ver = client.beta.skills.versions.create(
                    skill_id=skill_id,
                    files=files_from_dir(str(staged)),
                )
                d = ver.model_dump()
                updated.append((slug, d.get("version")))
                hashes[slug] = cur_hash
            except Exception as e:
                failed.append((slug, f"{type(e).__name__}: {str(e)[:120]}"))

    HASH_FILE.write_text(json.dumps(hashes, indent=2))

    print(f"Updated: {len(updated)}")
    for s, v in updated:
        print(f"  {s} -> {v}")
    print(f"Skipped (unchanged): {len(skipped)}")
    print(f"Missing local source: {len(missing)} {missing}")
    if failed:
        print(f"FAILED: {len(failed)}")
        for s, e in failed:
            print(f"  {s}: {e}")
        sys.exit(2)


if __name__ == "__main__":
    main()
