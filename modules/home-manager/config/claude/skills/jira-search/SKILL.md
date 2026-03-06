---
name: jira-search
description: Search and view Jira tickets using JQL queries. Use when user wants to find tickets, list assignments, check status, or view ticket details. Read-only operations only.
---

# Jira Search

Search for tickets and view ticket details.

## Setup (one-time)

Create `~/.claude/skills/jira/.env` with your credentials (see `.env.example`).

## Search Tickets

```bash
~/.claude/skills/jira/python ~/.claude/skills/jira-search/scripts/search.py \
  --jql "assignee = currentUser() AND status != Done"
```

**Common JQL patterns:**
- Your open tickets: `assignee = currentUser() AND status != Done`
- Your tickets in sprint: `assignee = currentUser() AND sprint in openSprints()`
- High priority bugs: `type = Bug AND priority = High`
- Recent updates: `updated >= -7d`
- Specific project: `project = PROJ`

## View Ticket Details

```bash
~/.claude/skills/jira/python ~/.claude/skills/jira-search/scripts/view_ticket.py --key PROJ-123
```

Shows summary, description, status, priority, assignee.

## Search Tips

- Use `currentUser()` for "my tickets"
- Combine criteria with `AND`
- Status names in quotes if spaces: `status = "In Progress"`
- Date filters: `-7d` (last 7 days), `-1w` (last week)
