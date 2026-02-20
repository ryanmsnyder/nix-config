#!/usr/bin/env python3
"""
Add a comment to a Jira ticket with markdown support.
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

def add_comment(key, comment_text):
    """Add a comment to a Jira ticket."""
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
    
    # Convert markdown to ADF
    adf_body = md_to_adf(comment_text)
    
    # Add the comment
    url = f"{base_url}/rest/api/3/issue/{key}/comment"
    
    try:
        response = requests.post(
            url,
            json={"body": adf_body},
            auth=(email, token),
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        
        if response.status_code in (200, 201):
            result = response.json()
            comment_id = result.get("id")
            print(f"Comment added: {comment_id}")
            return comment_id
        else:
            print(f"Error {response.status_code}: Failed to add comment", file=sys.stderr)
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
        description="Add a comment to a Jira ticket",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --key PROJ-123 --comment "Simple comment"
  %(prog)s --key PROJ-123 --comment "**Status:** Complete ✅"
        """
    )
    parser.add_argument("--key", required=True, help="Ticket key (e.g., PROJ-123)")
    parser.add_argument("--comment", required=True, help="Comment text (supports markdown)")
    
    args = parser.parse_args()
    
    add_comment(args.key, args.comment)

if __name__ == "__main__":
    main()