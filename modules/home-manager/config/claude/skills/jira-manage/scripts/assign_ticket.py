#!/usr/bin/env python3
"""Assign a Jira ticket to a user."""
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

def assign_ticket(key, assignee):
    base_url = os.environ.get("JIRA_BASE_URL", "").rstrip("/")
    email = os.environ.get("JIRA_EMAIL")
    token = os.environ.get("JIRA_API_TOKEN")
    
    if not all([base_url, email, token]):
        print("Error: Set JIRA_BASE_URL, JIRA_EMAIL, JIRA_API_TOKEN in .env", file=sys.stderr)
        sys.exit(1)
    
    # Handle "me" shortcut
    if assignee.lower() == "me":
        r = requests.get(f"{base_url}/rest/api/3/myself", auth=(email, token), timeout=30)
        if r.status_code == 200:
            account_id = r.json()["accountId"]
        else:
            print("Error: Could not get your account ID", file=sys.stderr)
            sys.exit(1)
    else:
        # Look up by email
        r = requests.get(
            f"{base_url}/rest/api/3/user/search",
            params={"query": assignee},
            auth=(email, token),
            timeout=30
        )
        if r.status_code == 200 and r.json():
            account_id = r.json()[0]["accountId"]
        else:
            print(f"Error: User '{assignee}' not found", file=sys.stderr)
            sys.exit(1)
    
    # Assign ticket
    r = requests.put(
        f"{base_url}/rest/api/3/issue/{key}/assignee",
        json={"accountId": account_id},
        auth=(email, token),
        headers={"Content-Type": "application/json"},
        timeout=30
    )
    
    if r.status_code == 204:
        print(f"Assigned: {key} → {assignee}")
    else:
        print(f"Error {r.status_code}: Failed to assign", file=sys.stderr)
        print(r.text, file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Assign Jira ticket")
    p.add_argument("--key", required=True, help="Ticket key (e.g., PROJ-123)")
    p.add_argument("--assignee", required=True, help="Email address or 'me'")
    args = p.parse_args()
    
    assign_ticket(args.key, args.assignee)