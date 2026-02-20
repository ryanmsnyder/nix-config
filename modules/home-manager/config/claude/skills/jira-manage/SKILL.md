---
name: jira-manage
description: Create tickets, update ticket fields, change status, and assign tickets. Use when creating bugs/tasks/stories, updating summaries/descriptions/priorities, changing workflow status, or assigning work. Supports markdown in descriptions.
---

# Jira Manage

Create, update, and transition tickets.

## Setup (one-time)

```bash
cd ~/.claude/skills/jira
cp .env.example .env
# Edit .env with your credentials
./setup.sh
```

## Create Ticket

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-manage/scripts/create_ticket.py \
  --project PROJ \
  --type Bug \
  --summary "Fix login issue" \
  --description "**Problem:** Users can't login"
```

**Options:**
- `--priority` High, Medium, Low
- `--labels` space-separated labels
- `--assignee` email address

## Update Ticket

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-manage/scripts/update_ticket.py \
  --key PROJ-123 \
  --summary "New title" \
  --priority High
```

## Change Status

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-manage/scripts/transition_ticket.py \
  --key PROJ-123 \
  --status "In Progress"
```

**Common statuses:** To Do, In Progress, In Review, Done, Blocked, Ready for QA

**Special handling for "Ready for QA":**
- Automatically updates Code Changes field with latest git commit URL
- Can provide custom URL: `--code-changes-url "https://github.com/org/repo/commit/abc123"`
- Auto-detects commit URL from current git repository if not provided

**How it works:**
- Matches target status name (handles transitions with suffixes like "(2)")
- For "Ready for QA" transitions, automatically populates required Code Changes field
- Uses ADF format with plain text (URL displays as plain text, not as clickable link)

## Assign Ticket

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-manage/scripts/assign_ticket.py \
  --key PROJ-123 \
  --assignee "user@example.com"
```

Use `--assignee me` to assign to yourself.

## Add to Sprint

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-manage/scripts/add_to_sprint.py --key PROJ-123
```

Adds ticket to the current active sprint. Optionally specify a sprint ID:

```bash
python3 ../jira-manage/scripts/add_to_sprint.py --key PROJ-123 --sprint-id 456
```

## List Available Transitions

```bash
cd ~/.claude/skills/jira && source .venv/bin/activate && \
python3 ../jira-manage/scripts/list_transitions.py --key PROJ-123
```

## Markdown Support

Descriptions support:
- `**bold**` and `*italic*`
- Lists, code blocks, links
- Emojis: ✅ ❌ ⚠️
