#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Setting up Jira skills shared environment..."

# Check for .env file
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo "Please copy .env.example to .env and fill in your Jira credentials"
    exit 1
fi

# Create shared venv
echo "Creating Python virtual environment..."
python3 -m venv .venv

# Activate and install Python dependencies
echo "Installing Python dependencies..."
source .venv/bin/activate
pip install -q --upgrade pip
pip install -q -r requirements.txt

# Install npm packages for md2adf conversion
echo "Installing Node.js dependencies..."
npm install --silent

echo "✅ Jira skills setup complete!"
echo ""
echo "All Jira skills (comments, manage, search) now share:"
echo "  - .env (credentials)"
echo "  - .venv/ (Python environment)"
echo "  - node_modules/ (for markdown-to-ADF conversion)"
