---
name: jira-comments
description: Add, update, and view comments on Jira tickets with markdown formatting. Use when user wants to add status updates, read comments, or communicate about tickets. Converts markdown to Atlassian Document Format (ADF).
---

# Jira Comments

Communicate on tickets with formatted comments.

## Setup (one-time)

```bash
cd ~/.claude/skills/jira
cp .env.example .env
# Edit .env with your credentials
./setup.sh
```

## Add Comment

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-comments/scripts/add_comment.py \
  --key PROJ-123 \
  --comment "**Status:** Complete ✅

Changes:
- Fixed bug
- Added tests"
```

## Update Comment

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-comments/scripts/update_comment.py \
  --key PROJ-123 \
  --comment-id 10001 \
  --comment "**Updated** info"
```

## View Comments

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-comments/scripts/view_comments.py --key PROJ-123
```

## Markdown Support

All comments support:
- `**bold**` and `*italic*`
- Lists with `-` or `1.`
- `code` and code blocks
- Links: `[text](url)`
- Emojis: ✅ ❌ ⚠️
