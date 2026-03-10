#!/usr/bin/env python3
"""View detailed information about a Jira ticket."""
import os, sys, argparse, requests
from pathlib import Path

# Load .env
env_file = Path(os.environ.get("JIRA_ENV_FILE", os.path.expanduser("~/.claude/skills/jira/.env")))
if env_file.exists():
    for line in open(env_file):
        line = line.strip()
        if line and not line.startswith("#") and "=" in line:
            key, val = line.split("=", 1)
            os.environ.setdefault(key, val)

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

def view_ticket(key, no_comments=False):
    base_url = os.environ.get("JIRA_BASE_URL", "").rstrip("/")
    email = os.environ.get("JIRA_EMAIL")
    token = os.environ.get("JIRA_API_TOKEN")
    
    if not all([base_url, email, token]):
        print("Error: Set JIRA_BASE_URL, JIRA_EMAIL, JIRA_API_TOKEN in .env", file=sys.stderr)
        sys.exit(1)
    
    r = requests.get(
        f"{base_url}/rest/api/3/issue/{key}",
        params={"fields": "summary,issuetype,status,priority,assignee,reporter,description,labels,attachment,created,updated"},
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

    attachments = fields.get("attachment", [])
    if attachments:
        print(f"\nAttachments ({len(attachments)}):")
        for a in attachments:
            print(f"  [{a['id']}] {a['filename']} ({a['mimeType']}, {a['size']} bytes)")
            if a["mimeType"].startswith("text/"):
                r2 = requests.get(
                    f"{base_url}/rest/api/3/attachment/content/{a['id']}",
                    auth=(email, token),
                    timeout=30
                )
                if r2.status_code == 200:
                    print(f"\n--- {a['filename']} ---")
                    print(r2.text)
                    print(f"--- end {a['filename']} ---")

    print(f"\nCreated: {fields.get('created', '')}")
    print(f"Updated: {fields.get('updated', '')}")

    if not no_comments:
        r2 = requests.get(
            f"{base_url}/rest/api/3/issue/{key}/comment",
            auth=(email, token),
            timeout=30
        )
        if r2.status_code == 200:
            comments = r2.json().get("comments", [])
            if comments:
                print(f"\nComments ({len(comments)}):\n")
                for comment in comments:
                    author = comment.get("author", {}).get("displayName", "Unknown")
                    created = comment.get("created", "")
                    comment_text = extract_text_from_adf(comment.get("body", {}))
                    print(f"[{comment['id']}] {author} - {created}")
                    print(f"{comment_text}\n")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="View Jira ticket details")
    p.add_argument("--key", required=True, help="Ticket key (e.g., PROJ-123)")
    p.add_argument("--no-comments", action="store_true", help="Skip fetching comments")
    args = p.parse_args()

    view_ticket(args.key, no_comments=args.no_comments)