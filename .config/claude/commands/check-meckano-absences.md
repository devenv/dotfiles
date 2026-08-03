---
description: Check Slack #admin for sick days/PTO and report them in Meckano app
---

# Meckano Absence Reporting Workflow

You are helping the user check for absences that need to be reported in Meckano (Israeli time tracking app).

## Step 1: Ensure Android Emulator is Running

First check if the emulator is already running:
```bash
~/Library/Android/sdk/platform-tools/adb devices
```

If no devices are shown, launch the emulator:
```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@21 && \
export ANDROID_HOME=~/Library/Android/sdk && \
~/Library/Android/sdk/emulator/emulator -avd Meckano_Device -no-snapshot-load &
```

Wait 30-60 seconds for the emulator to fully boot.

## Step 2: Check Slack #admin Channel

Use the Slack API to fetch messages from the #admin channel for the last month (from the 20th of last month to the 19th of current month).

**Important filtering rules:**
- User ID to check: U0566PX903F (boris@nilus.com)
- **ONLY** report these as absences requiring Meckano entry:
  - Messages containing "PTO" (case insensitive)
  - Messages containing "Sick" WITHOUT "WFH" or "SFH" in the same message
- **IGNORE** these (they are work days):
  - "WFH" (Work From Home) - even if it says "WFH (sick)"
  - "SFH" (Sick From Home)
  - Any message that indicates working from a different location

**Slack API Details:**
- Tokens from environment: `SLACK_MCP_XOXC_TOKEN` and `SLACK_MCP_XOXD_TOKEN`
- Channel ID: C03C5AE5481 (#admin)
- User ID: U0566PX903F
- Use POST requests with form data
- Cookie header: `d={url_decoded_xoxd_token}`

**Example Python code to fetch messages:**
```python
import json
import urllib.parse
import urllib.request
import datetime
from collections import defaultdict

# Tokens
xoxc_token = os.environ.get('SLACK_MCP_XOXC_TOKEN')
xoxd_token_encoded = os.environ.get('SLACK_MCP_XOXD_TOKEN')
xoxd_token = urllib.parse.unquote(xoxd_token_encoded)

# Calculate date range (20th of last month to 19th of current month)
today = datetime.date.today()
if today.day >= 20:
    start_date = datetime.date(today.year, today.month, 20)
    next_month = today.month + 1 if today.month < 12 else 1
    next_year = today.year if today.month < 12 else today.year + 1
    end_date = datetime.date(next_year, next_month, 19)
else:
    prev_month = today.month - 1 if today.month > 1 else 12
    prev_year = today.year if today.month > 1 else today.year - 1
    start_date = datetime.date(prev_year, prev_month, 20)
    end_date = datetime.date(today.year, today.month, 19)

# Fetch messages
url = 'https://slack.com/api/conversations.history'
form_data = {
    'token': xoxc_token,
    'channel': 'C03C5AE5481',
    'oldest': str(int(start_date.timestamp())),
    'latest': str(int(end_date.timestamp()) + 86400),
    'limit': '200'
}

data = urllib.parse.urlencode(form_data).encode('utf-8')
headers = {
    'Cookie': f'd={xoxd_token}',
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
    'Origin': 'https://app.slack.com'
}

req = urllib.request.Request(url, data=data, headers=headers, method='POST')
```

## Step 3: Analyze and Filter Messages

For each message from user U0566PX903F:
1. Parse the date from the timestamp
2. Get the message text
3. Apply filtering rules:
   - **REPORT if:** "PTO" in text OR ("sick" in text AND "wfh" NOT in text AND "sfh" NOT in text)
   - **IGNORE if:** "wfh" in text OR "sfh" in text (these are work days)

Create a list of dates that need to be reported with their types (PTO or Sick).

## Step 4: Check Meckano App

Launch Meckano if not already open:
```bash
~/Library/Android/sdk/platform-tools/adb shell am start -n com.kfir.Meckano/.ActivitySplash
```

Take a screenshot to verify:
```bash
~/Library/Android/sdk/platform-tools/adb shell screencap -p /sdcard/meckano.png && \
~/Library/Android/sdk/platform-tools/adb pull /sdcard/meckano.png /tmp/meckano.png
```

## Step 5: Navigate to Reports

Tap the Reports button at the bottom of the main screen:
```bash
~/Library/Android/sdk/platform-tools/adb shell input tap 149 2251
```

Wait 2 seconds for the page to load.

## Step 6: For Each Date Needing Reporting

For each sick day or PTO date found:

1. Navigate to the correct month if needed (use left/right arrows)
2. Scroll to find the date
3. Tap on the date row
4. Choose the appropriate option:
   - For sick days: Look for "Report Absence" or sick day option
   - For PTO: Look for PTO/vacation option
5. Save/confirm the entry

## Step 7: Summary Report

After processing all dates, provide a summary:
```
✅ Meckano Absence Report Complete

Period checked: [start_date] to [end_date]

Found absences requiring Meckano entry:
[List each date with type]

Already in Meckano:
[List dates already recorded]

No action needed:
[List WFH days that were ignored]

Total absences reported: X
```

## Important Notes

- **WFH is NOT a sick day** - people work from home, they're still working
- Only "Sick" without WFH/SFH qualifies as a real sick day
- PTO is always an absence
- The date range is always from the 20th of one month to the 19th of the next
- Meckano app may have time entries that need absence classification added
- The emulator may take time to boot - be patient
