#!/usr/bin/sh
date +%Y-%m-%d
gcal list -f `date +%Y-%m-%d` -t `date -d "+7 day" +%Y-%m-%d` | tail -n+2 | less -p "`date +%Y-%m-%d` \\d\\d:\\d\\d"
