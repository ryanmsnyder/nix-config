#!/usr/bin/env python3
"""View detailed information about a Jira ticket."""
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

def extract_text_from_adf(adf):
    """Extract plain text from ADF document."""
    if not adf or not isinstance(adf, dict):
        return ""
    
    text_parts = []
    
    def walk(node):
        if isinstance(node, dict):
            if node.get("type") == "text":
                text_parts.append(node.get("text", ""))
            if "content" in node:
                for child in node["content"]:
                    walk(child)
        elif isinstance(node, list):
            for item in node:
                walk(item)
    
    walk(adf)
    return " ".join(text_parts)

def view_ticket(key):
    base_url = os.environ.get("JIRA_BASE_URL", "").rstrip("/")
    email = os.environ.get("JIRA_EMAIL")
    token = os.environ.get("JIRA_API_TOKEN")
    
    if not all([base_url, email, token]):
        print("Error: Set JIRA_BASE_URL, JIRA_EMAIL, JIRA_API_TOKEN in .env", file=sys.stderr)
        sys.exit(1)
    
    r = requests.get(
        f"{base_url}/rest/api/3/issue/{key}",
        auth=(email, token),
        timeout=30
    )
    
    if r.status_code != 200:
        print(f"Error {r.status_code}: Could not get ticket", file=sys.stderr)
        print(r.text, file=sys.stderr)
        sys.exit(1)
    
    issue = r.json()
    fields = issue["fields"]
    
    print(f"Ticket: {key}")
    print(f"Type: {fields.get('issuetype', {}).get('name', '')}")
    print(f"Status: {fields.get('status', {}).get('name', '')}")
    print(f"Priority: {fields.get('priority', {}).get('name', 'None')}")
    
    assignee = fields.get("assignee", {})
    assignee_name = assignee.get("displayName", "Unassigned") if assignee else "Unassigned"
    print(f"Assignee: {assignee_name}")
    
    reporter = fields.get("reporter", {})
    reporter_name = reporter.get("displayName", "Unknown") if reporter else "Unknown"
    print(f"Reporter: {reporter_name}")
    
    print(f"\nSummary: {fields.get('summary', '')}")
    
    description = fields.get("description")
    if description:
        desc_text = extract_text_from_adf(description)
        if desc_text:
            print(f"\nDescription:\n{desc_text}")
    
    labels = fields.get("labels", [])
    if labels:
        print(f"\nLabels: {', '.join(labels)}")
    
    print(f"\nCreated: {fields.get('created', '')}")
    print(f"Updated: {fields.get('updated', '')}")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="View Jira ticket details")
    p.add_argument("--key", required=True, help="Ticket key (e.g., PROJ-123)")
    args = p.parse_args()
    
    view_ticket(args.key)