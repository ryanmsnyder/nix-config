#!/usr/bin/env python3
"""
Update a Jira ticket with markdown description support.
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
        sys.exit(1)
    except Exception as e:
        print(f"Error running md2adf.js: {e}", file=sys.stderr)
        sys.exit(1)

def update_ticket(key, summary=None, description=None, priority=None, labels=None):
    """Update a Jira ticket."""
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
    
    # Build fields to update
    fields = {}
    
    if summary:
        fields["summary"] = summary
    
    if description:
        fields["description"] = md_to_adf(description)
    
    if priority:
        fields["priority"] = {"name": priority}
    
    if labels is not None:  # Allow empty list to clear labels
        fields["labels"] = labels
    
    if not fields:
        print("Error: No fields to update. Provide at least one of: --summary, --description, --priority, --labels", file=sys.stderr)
        sys.exit(1)
    
    # Update the issue
    url = f"{base_url}/rest/api/3/issue/{key}"
    
    try:
        response = requests.put(
            url,
            json={"fields": fields},
            auth=(email, token),
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        
        if response.status_code == 204:
            print(f"Updated: {key}")
        else:
            print(f"Error {response.status_code}: Failed to update ticket", file=sys.stderr)
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
        description="Update a Jira ticket",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --key PROJ-123 --summary "New title"
  %(prog)s --key PROJ-123 --priority High --description "**Updated** description"
  %(prog)s --key PROJ-123 --labels urgent customer-facing
        """
    )
    parser.add_argument("--key", required=True, help="Ticket key (e.g., PROJ-123)")
    parser.add_argument("--summary", help="New summary/title")
    parser.add_argument("--description", help="New description (supports markdown)")
    parser.add_argument("--priority", help="New priority (e.g., High, Medium, Low)")
    parser.add_argument("--labels", nargs="*", help="New labels (replaces existing, use no args to clear)")
    
    args = parser.parse_args()
    
    update_ticket(
        key=args.key,
        summary=args.summary,
        description=args.description,
        priority=args.priority,
        labels=args.labels
    )

if __name__ == "__main__":
    main()