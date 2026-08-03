#!/usr/bin/env python3
"""
notion-post-prd.py — Post PRD content from Linear comments to Notion pages.

Finds AID tickets in "In AI Review" without a Notion attachment,
reads the PRD content from Linear comments, converts markdown to
Notion blocks, creates Notion pages, and attaches the URL back.

Runs standalone via cron or manually. No LLM needed.
"""

import json
import os
import re
import sys
import urllib.request
import urllib.error
from datetime import datetime, timezone

# --- Config ---
NOTION_TOKEN = os.environ.get("NOTION_TOKEN", "")
LINEAR_API_KEY = os.environ.get("LINEAR_API_KEY", "")
PRD_DATABASE_ID = "61477721-247e-4675-bc1e-6581086125a9"
AID_TEAM_ID = "5a190c03-c671-46c6-afbe-1eedc58db4c5"
IN_AI_REVIEW_STATE_ID = "41b2a4dc-c34a-4adf-994c-28fad5c6e997"
DRY_RUN = "--dry-run" in sys.argv
VERBOSE = "--verbose" in sys.argv or "-v" in sys.argv

def log(msg):
    ts = datetime.now(timezone.utc).strftime("%H:%M:%S")
    print(f"{ts} {msg}", flush=True)

def vlog(msg):
    if VERBOSE:
        log(f"  [debug] {msg}")

# --- HTTP helpers ---

def linear_gql(query):
    """Execute a Linear GraphQL query."""
    data = json.dumps({"query": query}).encode()
    req = urllib.request.Request(
        "https://api.linear.app/graphql",
        data=data,
        headers={
            "Content-Type": "application/json",
            "Authorization": LINEAR_API_KEY,
        },
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read())


def notion_api(endpoint, payload, method="POST"):
    """Call Notion API."""
    data = json.dumps(payload).encode()
    req = urllib.request.Request(
        f"https://api.notion.com/v1/{endpoint}",
        data=data,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {NOTION_TOKEN}",
            "Notion-Version": "2022-06-28",
        },
        method=method,
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            return json.loads(resp.read())
    except urllib.error.HTTPError as e:
        body = e.read().decode()
        log(f"  Notion API error {e.code}: {body[:500]}")
        raise


# --- Markdown → Notion blocks ---

def rich_text(text):
    """Convert a text string to Notion rich_text with inline formatting."""
    segments = []
    # Split on inline patterns: **bold**, *italic*, `code`
    # Process in order: code first (to avoid conflicts), then bold, then italic
    parts = re.split(r'(`[^`]+`)', text)
    for part in parts:
        if part.startswith('`') and part.endswith('`') and len(part) > 2:
            segments.append({
                "type": "text",
                "text": {"content": part[1:-1]},
                "annotations": {"code": True},
            })
        else:
            # Handle bold and italic within this part
            sub_parts = re.split(r'(\*\*[^*]+\*\*)', part)
            for sub in sub_parts:
                if sub.startswith('**') and sub.endswith('**') and len(sub) > 4:
                    segments.append({
                        "type": "text",
                        "text": {"content": sub[2:-2]},
                        "annotations": {"bold": True},
                    })
                elif sub:
                    # Handle italic
                    italic_parts = re.split(r'(\*[^*]+\*)', sub)
                    for ip in italic_parts:
                        if ip.startswith('*') and ip.endswith('*') and len(ip) > 2 and not ip.startswith('**'):
                            segments.append({
                                "type": "text",
                                "text": {"content": ip[1:-1]},
                                "annotations": {"italic": True},
                            })
                        elif ip:
                            segments.append({
                                "type": "text",
                                "text": {"content": ip},
                            })
    # Notion limit: 2000 chars per rich_text content
    # Split long segments
    result = []
    for seg in segments:
        content = seg["text"]["content"]
        while len(content) > 2000:
            chunk = dict(seg)
            chunk["text"] = {"content": content[:2000]}
            result.append(chunk)
            content = content[2000:]
        if content:
            final = dict(seg)
            final["text"] = {"content": content}
            result.append(final)
    return result if result else [{"type": "text", "text": {"content": ""}}]


def md_to_notion_blocks(md_text):
    """Convert markdown text to a list of Notion block objects."""
    blocks = []
    lines = md_text.split('\n')
    i = 0
    code_block_lines = []
    code_lang = ""
    in_code_block = False

    while i < len(lines):
        line = lines[i]

        # Code block toggle
        if line.startswith('```'):
            if not in_code_block:
                in_code_block = True
                code_lang = line[3:].strip() or "plain text"
                code_block_lines = []
            else:
                in_code_block = False
                code_content = '\n'.join(code_block_lines)
                # Notion code block max 2000 chars
                if len(code_content) > 2000:
                    code_content = code_content[:1997] + "..."
                blocks.append({
                    "object": "block",
                    "type": "code",
                    "code": {
                        "rich_text": [{"type": "text", "text": {"content": code_content}}],
                        "language": code_lang,
                    },
                })
            i += 1
            continue

        if in_code_block:
            code_block_lines.append(line)
            i += 1
            continue

        # Divider
        if line.strip() == '---' or line.strip() == '***':
            blocks.append({"object": "block", "type": "divider", "divider": {}})
            i += 1
            continue

        # Headings
        if line.startswith('# '):
            blocks.append({
                "object": "block", "type": "heading_1",
                "heading_1": {"rich_text": rich_text(line[2:].strip())},
            })
            i += 1
            continue
        if line.startswith('## '):
            blocks.append({
                "object": "block", "type": "heading_2",
                "heading_2": {"rich_text": rich_text(line[3:].strip())},
            })
            i += 1
            continue
        if line.startswith('### '):
            blocks.append({
                "object": "block", "type": "heading_3",
                "heading_3": {"rich_text": rich_text(line[4:].strip())},
            })
            i += 1
            continue

        # Checkbox items
        m = re.match(r'^[-*]\s+\[([ xX])\]\s+(.*)', line)
        if m:
            checked = m.group(1).lower() == 'x'
            blocks.append({
                "object": "block", "type": "to_do",
                "to_do": {
                    "rich_text": rich_text(m.group(2)),
                    "checked": checked,
                },
            })
            i += 1
            continue

        # Bulleted list
        m = re.match(r'^[-*]\s+(.*)', line)
        if m:
            blocks.append({
                "object": "block", "type": "bulleted_list_item",
                "bulleted_list_item": {"rich_text": rich_text(m.group(1))},
            })
            i += 1
            continue

        # Numbered list
        m = re.match(r'^\d+\.\s+(.*)', line)
        if m:
            blocks.append({
                "object": "block", "type": "numbered_list_item",
                "numbered_list_item": {"rich_text": rich_text(m.group(1))},
            })
            i += 1
            continue

        # Blockquote
        if line.startswith('> '):
            blocks.append({
                "object": "block", "type": "quote",
                "quote": {"rich_text": rich_text(line[2:].strip())},
            })
            i += 1
            continue

        # Empty line — skip
        if line.strip() == '':
            i += 1
            continue

        # Paragraph (default)
        blocks.append({
            "object": "block", "type": "paragraph",
            "paragraph": {"rich_text": rich_text(line)},
        })
        i += 1

    return blocks


def create_notion_page(parent_type, parent_id, title, md_content, status=None):
    """Create a Notion page with markdown content converted to blocks.

    parent_type: "database_id" or "page_id"
    Returns the created page dict (with id, url).
    """
    blocks = md_to_notion_blocks(md_content)

    # Notion limit: max 100 children per request
    first_batch = blocks[:100]
    remaining = blocks[100:]

    payload = {
        "parent": {parent_type: parent_id},
        "properties": {
            "Name": {"title": [{"type": "text", "text": {"content": title}}]},
        },
        "children": first_batch,
    }

    if status and parent_type == "database_id":
        payload["properties"]["Status"] = {"status": {"name": status}}

    if DRY_RUN:
        log(f"  [dry-run] Would create page: {title} ({len(blocks)} blocks)")
        return {"id": "dry-run-id", "url": "https://notion.so/dry-run"}

    page = notion_api("pages", payload)
    page_id = page["id"]
    vlog(f"Created page {page_id} with {len(first_batch)} blocks")

    # Append remaining blocks in batches of 100
    while remaining:
        batch = remaining[:100]
        remaining = remaining[100:]
        notion_api(f"blocks/{page_id}/children", {"children": batch}, method="PATCH")
        vlog(f"Appended {len(batch)} blocks to {page_id}")

    return page


def extract_prd_sections(comments):
    """Extract PRD, Tech Design, and ATP content from Linear comments.

    Returns dict with keys: prd, tech_design, atp (each is markdown string or None).
    The PRD pipeline posts all content in a single comment starting with
    '## PRD + Tech Design + ATP' or similar, with the actual PRD content
    after '### PRD Content' heading.
    """
    result = {"prd": None, "tech_design": None, "atp": None}

    # Find the main PRD content comment (longest comment with PRD in it)
    prd_comments = [c for c in comments if "PRD" in c.get("body", "")[:200]]
    if not prd_comments:
        return result

    # Sort by length descending — the full content comment is usually the longest
    prd_comments.sort(key=lambda c: len(c.get("body", "")), reverse=True)
    body = prd_comments[0]["body"]

    # Try to find the actual PRD content section
    # Look for "# PRD:" or "### PRD Content" as the start
    prd_start = None
    for marker in ["### PRD Content\n", "# PRD:", "## PRD:"]:
        idx = body.find(marker)
        if idx >= 0:
            prd_start = idx
            break

    if prd_start is not None:
        result["prd"] = body[prd_start:].strip()
    else:
        # Use the whole comment as PRD content
        result["prd"] = body.strip()

    # TODO: extract TD and ATP from separate comments or sections if present
    # For now, they may be in separate comments
    for c in comments:
        b = c.get("body", "")
        if b.startswith("## Tech Design:") or b.startswith("# Tech Design:"):
            result["tech_design"] = b
        elif b.startswith("## ATP:") or b.startswith("# ATP:") or "Acceptance Test Plan" in b[:100]:
            result["atp"] = b

    return result


# --- Main ---

def main():
    if not LINEAR_API_KEY:
        print("ERROR: LINEAR_API_KEY not set. Source .env first.", file=sys.stderr)
        sys.exit(1)
    if not NOTION_TOKEN:
        print("ERROR: NOTION_TOKEN not set.", file=sys.stderr)
        sys.exit(1)

    log("=== Notion PRD Poster ===")

    # 1. Get AID tickets in "In AI Review"
    query = '''
    {
      team(id: "%s") {
        issues(
          filter: { state: { id: { eq: "%s" } } }
          first: 50
        ) {
          nodes {
            id
            identifier
            title
            attachments { nodes { url } }
            comments(first: 10) {
              nodes { body createdAt user { name } }
            }
          }
        }
      }
    }
    ''' % (AID_TEAM_ID, IN_AI_REVIEW_STATE_ID)

    resp = linear_gql(query)
    tickets = resp["data"]["team"]["issues"]["nodes"]
    log(f"Found {len(tickets)} tickets in AI Review")

    posted = 0
    for ticket in tickets:
        tid = ticket["identifier"]
        title = ticket["title"]
        attachments = [a["url"] for a in ticket["attachments"]["nodes"]]

        # Skip if already has Notion attachment
        has_notion = any("notion.so" in url or "notion.site" in url for url in attachments)
        if has_notion:
            vlog(f"{tid}: already has Notion attachment, skipping")
            continue

        log(f"{tid}: {title[:60]} — no Notion attachment, posting...")

        # Extract PRD content from comments
        sections = extract_prd_sections(ticket["comments"]["nodes"])
        if not sections["prd"]:
            log(f"  {tid}: no PRD content found in comments, skipping")
            continue

        prd_content = sections["prd"]
        log(f"  PRD content: {len(prd_content)} chars")

        # Derive domain name from title
        domain = title
        for prefix in ["PRD — ", "PRD — ", "[PRD] ", "PRD: ", "PRD - "]:
            if domain.startswith(prefix):
                domain = domain[len(prefix):]
                break

        # Create parent PRD page in database
        page_title = f"PRD: {domain}"
        try:
            parent_page = create_notion_page(
                "database_id", PRD_DATABASE_ID,
                page_title, prd_content, status="In review"
            )
        except Exception as e:
            log(f"  {tid}: failed to create Notion page: {e}")
            continue

        notion_url = parent_page.get("url", "")
        parent_page_id = parent_page.get("id", "")
        log(f"  Created: {notion_url}")

        # Create TD subpage if available
        if sections["tech_design"] and parent_page_id and not DRY_RUN:
            try:
                td_page = create_notion_page(
                    "page_id", parent_page_id,
                    f"Tech Design: {domain}", sections["tech_design"]
                )
                vlog(f"  TD subpage: {td_page.get('url', '')}")
            except Exception as e:
                log(f"  {tid}: TD subpage failed: {e}")

        # Create ATP subpage if available
        if sections["atp"] and parent_page_id and not DRY_RUN:
            try:
                atp_page = create_notion_page(
                    "page_id", parent_page_id,
                    f"ATP: {domain}", sections["atp"]
                )
                vlog(f"  ATP subpage: {atp_page.get('url', '')}")
            except Exception as e:
                log(f"  {tid}: ATP subpage failed: {e}")

        # Attach Notion URL to Linear ticket
        if notion_url and not DRY_RUN:
            attach_query = '''
            mutation {
              attachmentCreate(input: {
                issueId: "%s"
                url: "%s"
                title: "%s"
                subtitle: "Full PRD on Notion"
              }) { success }
            }
            ''' % (ticket["id"], notion_url, page_title.replace('"', '\\"'))
            try:
                linear_gql(attach_query)
                log(f"  Attached to {tid}")
            except Exception as e:
                log(f"  {tid}: attach failed: {e}")

        posted += 1

    log(f"Done. Posted {posted} PRDs to Notion.")


if __name__ == "__main__":
    main()
