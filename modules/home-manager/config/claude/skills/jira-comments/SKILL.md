---
name: jira-comments
description: Add, update, and view comments on Jira tickets with markdown formatting. Use when user wants to add status updates, read comments, or communicate about tickets. Converts markdown to Atlassian Document Format (ADF).
---

# Jira Comments

Communicate on tickets with formatted comments.

## Setup (one-time)

Create `~/.claude/skills/jira/.env` with your credentials (see `.env.example`).

## Add Comment

```bash
~/.claude/skills/jira/python ~/.claude/skills/jira-comments/scripts/add_comment.py \
  --key PROJ-123 \
  --comment "**Status:** Complete ✅

Changes:
- Fixed bug
- Added tests"
```

## Update Comment

```bash
~/.claude/skills/jira/python ~/.claude/skills/jira-comments/scripts/update_comment.py \
  --key PROJ-123 \
  --comment-id 10001 \
  --comment "**Updated** info"
```

## View Comments

```bash
~/.claude/skills/jira/python ~/.claude/skills/jira-comments/scripts/view_comments.py --key PROJ-123
```

## Markdown Support

All comments support:
- `**bold**` and `*italic*`
- Lists with `-` or `1.`
- `code` and code blocks
- Links: `[text](url)`
- Emojis: ✅ ❌ ⚠️
