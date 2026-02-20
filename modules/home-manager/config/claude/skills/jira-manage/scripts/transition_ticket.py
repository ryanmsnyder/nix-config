#!/usr/bin/env python3
"""Transition a Jira ticket to a new status."""
import os, sys, json, argparse, requests, subprocess
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

def get_latest_commit_url():
    """Get the GitHub URL for the latest commit."""
    try:
        # Try to find git repo from current directory or look in common locations
        cwd = os.getcwd()

        # Get remote URL
        remote = subprocess.check_output(
            ["git", "config", "--get", "remote.origin.url"],
            text=True,
            cwd=cwd,
            stderr=subprocess.DEVNULL
        ).strip()

        # Convert SSH to HTTPS if needed
        if remote.startswith("git@github.com:"):
            remote = remote.replace("git@github.com:", "https://github.com/")
        if remote.endswith(".git"):
            remote = remote[:-4]

        # Get latest commit hash
        commit_hash = subprocess.check_output(
            ["git", "rev-parse", "HEAD"],
            text=True,
            cwd=cwd,
            stderr=subprocess.DEVNULL
        ).strip()

        return f"{remote}/commit/{commit_hash}"
    except:
        return None

def transition_ticket(key, status, code_changes_url=None):
    base_url = os.environ.get("JIRA_BASE_URL", "").rstrip("/")
    email = os.environ.get("JIRA_EMAIL")
    token = os.environ.get("JIRA_API_TOKEN")

    if not all([base_url, email, token]):
        print("Error: Set JIRA_BASE_URL, JIRA_EMAIL, JIRA_API_TOKEN in .env", file=sys.stderr)
        sys.exit(1)

    # Get available transitions
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

    # Find matching transition by target status name (case-insensitive)
    # This handles cases where transition names have suffixes like "(2)"
    transition_id = None
    status_lower = status.lower()

    for t in transitions:
        target_status = t["to"]["name"].lower()
        if target_status == status_lower:
            transition_id = t["id"]
            break

    if not transition_id:
        print(f"Error: Status '{status}' not available", file=sys.stderr)
        print(f"Available transitions:", file=sys.stderr)
        for t in transitions:
            print(f"  - {t['to']['name']}", file=sys.stderr)
        sys.exit(1)

    # Check if Code Changes field is required for this transition
    # If transitioning to "Ready for QA", we need to set the Code Changes field
    requires_code_changes = False
    for t in transitions:
        if t["id"] == transition_id and t["to"]["name"].lower() == "ready for qa":
            requires_code_changes = True
            break

    # If Code Changes is required, update it first
    if requires_code_changes:
        if not code_changes_url:
            # Try to auto-detect from git
            code_changes_url = get_latest_commit_url()

        if code_changes_url:
            # Update Code Changes field in ADF format (plain text, no link markup)
            r = requests.put(
                f"{base_url}/rest/api/3/issue/{key}",
                auth=(email, token),
                json={
                    "fields": {
                        "customfield_10206": {
                            "type": "doc",
                            "version": 1,
                            "content": [
                                {
                                    "type": "paragraph",
                                    "content": [
                                        {
                                            "type": "text",
                                            "text": code_changes_url
                                        }
                                    ]
                                }
                            ]
                        }
                    }
                },
                timeout=30
            )

            if r.status_code not in (200, 204):
                print(f"Warning: Could not update Code Changes field", file=sys.stderr)
                print(f"Error {r.status_code}: {r.text}", file=sys.stderr)
                print(f"Attempting transition anyway...", file=sys.stderr)
            else:
                print(f"Updated Code Changes: {code_changes_url}")
        else:
            print(f"Warning: Ready for QA transition requires Code Changes field", file=sys.stderr)
            print(f"No --code-changes-url provided and could not auto-detect from git", file=sys.stderr)

    # Execute transition
    r = requests.post(
        f"{base_url}/rest/api/3/issue/{key}/transitions",
        json={"transition": {"id": transition_id}},
        auth=(email, token),
        headers={"Content-Type": "application/json"},
        timeout=30
    )

    if r.status_code == 204:
        print(f"Status changed: {key} → {status}")
    else:
        print(f"Error {r.status_code}: Failed to transition", file=sys.stderr)
        print(r.text, file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    p = argparse.ArgumentParser(description="Change Jira ticket status")
    p.add_argument("--key", required=True, help="Ticket key (e.g., PROJ-123)")
    p.add_argument("--status", required=True, help="New status (e.g., 'In Progress', 'Done')")
    p.add_argument("--code-changes-url", help="GitHub commit URL for Code Changes field (auto-detected from git if not provided)")
    args = p.parse_args()

    transition_ticket(args.key, args.status, args.code_changes_url)