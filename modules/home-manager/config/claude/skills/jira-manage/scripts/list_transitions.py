#!/usr/bin/env python3
"""List available transitions for a Jira ticket."""
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

def list_transitions(key):
    base_url = os.environ.get("JIRA_BASE_URL", "").rstrip("/")
    email = os.environ.get("JIRA_EMAIL")
    token = os.environ.get("JIRA_API_TOKEN")
    
    if not all([base_url, email, token]):
        print("Error: Set JIRA_BASE_URL, JIRA_EMAIL, JIRA_API_TOKEN in .env", file=sys.stderr)
        sys.exit(1)
    
    r = requests.get(
        f"{base_url}/rest/api/3/issue/{key}/transitions",
        auth=(email, token),
        timeout=30
    )
    
    if r.status_code != 200:
        print(f"Error {r.status_code}: Could not get transitions", file=sys.stderr)
        print(r.text, file=sys.stderr)
        sys.exit(1)
    
    transitions = r.json()["transitions"]
    
    print(f"Available transitions for {key}:")
    for t in transitions:
        print(f"  - {t['name']}")

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="List available transitions")
    p.add_argument("--key", required=True, help="Ticket key (e.g., PROJ-123)")
    args = p.parse_args()
    
    list_transitions(args.key)