#!/usr/bin/env python3
"""
Add a Jira ticket to the current active sprint.
"""
import os
import sys
import json
import argparse
import requests
from pathlib import Path

# Load .env file if it exists
env_file = Path(__file__).parent.parent / ".env"
if env_file.exists():
    with open(env_file) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                key, value = line.split("=", 1)
                os.environ[key] = value

def get_board_id(project_key, auth):
    """Get the board ID for a project. Prefers scrum boards over kanban."""
    base_url = os.environ["JIRA_BASE_URL"]
    url = f"{base_url}/rest/agile/1.0/board"

    response = requests.get(
        url,
        auth=auth,
        headers={"Accept": "application/json"},
        params={"projectKeyOrId": project_key}
    )

    if response.status_code != 200:
        print(f"Error getting board: {response.status_code}", file=sys.stderr)
        print(response.text, file=sys.stderr)
        sys.exit(1)

    boards = response.json().get("values", [])
    if not boards:
        print(f"No board found for project {project_key}", file=sys.stderr)
        sys.exit(1)

    # Prefer scrum boards (which support sprints) over kanban boards
    scrum_boards = [b for b in boards if b.get("type") == "scrum"]
    if scrum_boards:
        return scrum_boards[0]["id"]

    return boards[0]["id"]

def get_active_sprint(board_id, auth):
    """Get the active sprint for a board."""
    base_url = os.environ["JIRA_BASE_URL"]
    url = f"{base_url}/rest/agile/1.0/board/{board_id}/sprint"

    response = requests.get(
        url,
        auth=auth,
        headers={"Accept": "application/json"},
        params={"state": "active"}
    )

    if response.status_code != 200:
        print(f"Error getting active sprint: {response.status_code}", file=sys.stderr)
        print(response.text, file=sys.stderr)
        sys.exit(1)

    sprints = response.json().get("values", [])
    if not sprints:
        print(f"No active sprint found for board {board_id}", file=sys.stderr)
        sys.exit(1)

    return sprints[0]

def add_issue_to_sprint(sprint_id, issue_key, auth):
    """Add an issue to a sprint."""
    base_url = os.environ["JIRA_BASE_URL"]
    url = f"{base_url}/rest/agile/1.0/sprint/{sprint_id}/issue"

    payload = {
        "issues": [issue_key]
    }

    response = requests.post(
        url,
        auth=auth,
        headers={"Content-Type": "application/json"},
        json=payload
    )

    if response.status_code not in [200, 204]:
        print(f"Error adding issue to sprint: {response.status_code}", file=sys.stderr)
        print(response.text, file=sys.stderr)
        sys.exit(1)

    return True

def main():
    parser = argparse.ArgumentParser(description="Add a Jira ticket to the current active sprint")
    parser.add_argument("--key", required=True, help="Issue key (e.g., MIRA-160)")
    parser.add_argument("--sprint-id", type=int, help="Specific sprint ID (optional, defaults to active sprint)")
    args = parser.parse_args()

    # Check for required environment variables
    required_vars = ["JIRA_BASE_URL", "JIRA_EMAIL", "JIRA_API_TOKEN"]
    missing = [var for var in required_vars if var not in os.environ]
    if missing:
        print(f"Error: Missing environment variables: {', '.join(missing)}", file=sys.stderr)
        sys.exit(1)

    auth = (os.environ["JIRA_EMAIL"], os.environ["JIRA_API_TOKEN"])

    # Extract project key from issue key (e.g., MIRA-160 -> MIRA)
    project_key = args.key.split("-")[0]

    if args.sprint_id:
        sprint_id = args.sprint_id
        sprint_name = f"Sprint {sprint_id}"
    else:
        # Get board ID and active sprint
        board_id = get_board_id(project_key, auth)
        sprint = get_active_sprint(board_id, auth)
        sprint_id = sprint["id"]
        sprint_name = sprint["name"]

    # Add issue to sprint
    add_issue_to_sprint(sprint_id, args.key, auth)

    print(f"Added {args.key} to {sprint_name}")

if __name__ == "__main__":
    main()
