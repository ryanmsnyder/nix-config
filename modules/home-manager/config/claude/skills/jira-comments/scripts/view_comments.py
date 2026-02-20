#!/usr/bin/env python3
"""View comments on a Jira ticket."""
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

def view_comments(key):
    base_url = os.environ.get("JIRA_BASE_URL", "").rstrip("/")
    email = os.environ.get("JIRA_EMAIL")
    token = os.environ.get("JIRA_API_TOKEN")
    
    if not all([base_url, email, token]):
        print("Error: Set JIRA_BASE_URL, JIRA_EMAIL, JIRA_API_TOKEN in .env", file=sys.stderr)
        sys.exit(1)
    
    r = requests.get(
        f"{base_url}/rest/api/3/issue/{key}/comment",
        auth=(email, token),
        timeout=30
    )
    
    if r.status_code != 200:
        print(f"Error {r.status_code}: Could not get comments", file=sys.stderr)
        print(r.text, file=sys.stderr)
        sys.exit(1)
    
    data = r.json()
    comments = data.get("comments", [])
    
    if not comments:
        print(f"No comments on {key}")
        return
    
    print(f"Comments on {key}:\n")
    
    for comment in comments:
        comment_id = comment["id"]
        author = comment.get("author", {}).get("displayName", "Unknown")
        created = comment.get("created", "")
        body = comment.get("body", {})
        
        comment_text = extract_text_from_adf(body)
        
        print(f"[{comment_id}] {author} - {created}")
        print(f"{comment_text}\n")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="View Jira ticket comments")
    p.add_argument("--key", required=True, help="Ticket key (e.g., PROJ-123)")
    args = p.parse_args()
    
    view_comments(args.key)