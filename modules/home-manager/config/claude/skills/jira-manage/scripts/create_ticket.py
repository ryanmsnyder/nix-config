#!/usr/bin/env python3
"""
Create a Jira ticket with markdown description that gets converted to ADF.
"""
import os
import sys
import json
import argparse
import subprocess
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

def md_to_adf(markdown_text):
    """Convert markdown to ADF using the md2adf.js script."""
    script_dir = Path(__file__).parent
    md2adf_script = script_dir / "md2adf.js"
    
    if not md2adf_script.exists():
        print(f"Error: md2adf.js not found at {md2adf_script}", file=sys.stderr)
        sys.exit(1)
    
    try:
        result = subprocess.run(
            ["node", str(md2adf_script)],
            input=markdown_text,
            capture_output=True,
            text=True,
            check=False
        )
        
        if result.returncode != 0:
            print(f"Error converting markdown to ADF:", file=sys.stderr)
            print(result.stderr, file=sys.stderr)
            sys.exit(1)
        
        return json.loads(result.stdout)
    except json.JSONDecodeError as e:
        print(f"Error parsing ADF JSON: {e}", file=sys.stderr)
        print(f"Output was: {result.stdout}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error running md2adf.js: {e}", file=sys.stderr)
        sys.exit(1)

def get_account_id_by_email(base_url, email, token, search_email):
    """Look up a Jira user's account ID by email."""
    url = f"{base_url}/rest/api/3/user/search"
    try:
        response = requests.get(
            url,
            params={"query": search_email},
            auth=(email, token),
            timeout=30
        )
        response.raise_for_status()
        
        users = response.json()
        if users and len(users) > 0:
            return users[0]["accountId"]
        else:
            print(f"Warning: No user found with email {search_email}", file=sys.stderr)
            return None
    except Exception as e:
        print(f"Warning: Could not look up user {search_email}: {e}", file=sys.stderr)
        return None

def create_ticket(project, issue_type, summary, description=None, priority=None, labels=None, assignee_email=None, techops_team=None, channel_name=None):
    """Create a Jira ticket."""
    base_url = os.environ.get("JIRA_BASE_URL")
    email = os.environ.get("JIRA_EMAIL")
    token = os.environ.get("JIRA_API_TOKEN")

    if not all([base_url, email, token]):
        print("Error: Missing required environment variables", file=sys.stderr)
        print("Required: JIRA_BASE_URL, JIRA_EMAIL, JIRA_API_TOKEN", file=sys.stderr)
        print("Create a .env file in the skill directory or set them in your shell", file=sys.stderr)
        sys.exit(1)

    # Remove trailing slash from base URL if present
    base_url = base_url.rstrip("/")

    # Build fields
    fields = {
        "project": {"key": project},
        "summary": summary,
        "issuetype": {"name": issue_type}
    }

    # Add description if provided (convert markdown to ADF)
    if description:
        fields["description"] = md_to_adf(description)

    # Add optional fields
    if priority:
        fields["priority"] = {"name": priority}

    if labels:
        fields["labels"] = labels

    if assignee_email:
        account_id = get_account_id_by_email(base_url, email, token, assignee_email)
        if account_id:
            fields["assignee"] = {"accountId": account_id}

    # Add GOOS-specific fields
    if techops_team:
        fields["customfield_10178"] = {"value": techops_team}

    if channel_name:
        fields["customfield_10224"] = {"value": channel_name}
    
    # Create the issue
    url = f"{base_url}/rest/api/3/issue"
    
    try:
        response = requests.post(
            url,
            json={"fields": fields},
            auth=(email, token),
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        
        if response.status_code in (200, 201):
            result = response.json()
            issue_key = result.get("key")
            print(f"Created: {issue_key}")
            return issue_key
        else:
            print(f"Error {response.status_code}: Failed to create ticket", file=sys.stderr)
            try:
                error_data = response.json()
                print(json.dumps(error_data, indent=2), file=sys.stderr)
            except:
                print(response.text, file=sys.stderr)
            sys.exit(1)
            
    except requests.exceptions.RequestException as e:
        print(f"Request error: {e}", file=sys.stderr)
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(
        description="Create a Jira ticket with markdown support",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --project PROJ --type Bug --summary "Fix login" --description "Users cannot login"
  %(prog)s --project PROJ --type Story --summary "Add feature" --priority High --labels backend api
        """
    )
    parser.add_argument("--project", required=True, help="Project key (e.g., PROJ)")
    parser.add_argument("--type", required=True, help="Issue type (e.g., Bug, Task, Story)")
    parser.add_argument("--summary", required=True, help="Ticket summary/title")
    parser.add_argument("--description", help="Ticket description (supports markdown)")
    parser.add_argument("--priority", help="Priority (e.g., High, Medium, Low)")
    parser.add_argument("--labels", nargs="+", help="Labels to add")
    parser.add_argument("--assignee", help="Assignee email address")
    parser.add_argument("--techops-team", help="TechOps Team (GOOS project)")
    parser.add_argument("--channel-name", help="Channel Name (GOOS project)")

    args = parser.parse_args()

    create_ticket(
        project=args.project,
        issue_type=args.type,
        summary=args.summary,
        description=args.description,
        priority=args.priority,
        labels=args.labels,
        assignee_email=args.assignee,
        techops_team=args.techops_team,
        channel_name=args.channel_name
    )

if __name__ == "__main__":
    main()