#!/usr/bin/env python3
"""Search Jira tickets using JQL."""
import os, sys, argparse, requests
from pathlib import Path

SKILL_DIR = Path(__file__).parent.parent.parent / "jira"

# Load .env
env_file = SKILL_DIR / ".env"
if env_file.exists():
    for line in open(env_file):
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, val = line.split("=", 1)
            os.environ[key] = val

def search_tickets(jql, max_results=50):
    base_url = os.environ.get("JIRA_BASE_URL", "").rstrip("/")
    email = os.environ.get("JIRA_EMAIL")
    token = os.environ.get("JIRA_API_TOKEN")
    
    if not all([base_url, email, token]):
        print("Error: Set JIRA_BASE_URL, JIRA_EMAIL, JIRA_API_TOKEN in .env", file=sys.stderr)
        sys.exit(1)
    
    r = requests.post(
        f"{base_url}/rest/api/3/search/jql",
        json={
            "jql": jql,
            "maxResults": max_results,
            "fields": ["key", "summary", "status", "priority", "assignee", "issuetype"]
        },
        auth=(email, token),
        headers={"Content-Type": "application/json"},
        timeout=30
    )
    
    if r.status_code != 200:
        print(f"Error {r.status_code}: Search failed", file=sys.stderr)
        print(r.text, file=sys.stderr)
        sys.exit(1)
    
    data = r.json()
    issues = data.get("issues", [])
    total = data.get("total", 0)
    
    if not issues:
        print("No tickets found")
        return
    
    print(f"Found {total} ticket(s):\n")
    
    for issue in issues:
        key = issue["key"]
        fields = issue["fields"]
        summary = fields.get("summary", "")
        status = fields.get("status", {}).get("name", "Unknown")
        priority = fields.get("priority", {}).get("name", "None")
        assignee = fields.get("assignee", {})
        assignee_name = assignee.get("displayName", "Unassigned") if assignee else "Unassigned"
        issue_type = fields.get("issuetype", {}).get("name", "")
        
        print(f"{key}: {summary}")
        print(f"  Type: {issue_type} | Status: {status} | Priority: {priority}")
        print(f"  Assignee: {assignee_name}")
        print()

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Search Jira tickets with JQL")
    p.add_argument("--jql", required=True, help='JQL query (e.g., "assignee = currentUser()")')
    p.add_argument("--max", type=int, default=50, help="Maximum results (default: 50)")
    args = p.parse_args()
    
    search_tickets(args.jql, args.max)